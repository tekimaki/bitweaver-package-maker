<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="php_file_header.tpl"}}

require_once( '../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{{$package}}' );

/* =-=- CUSTOM BEGIN: security -=-= */
{{if !empty($customBlock.security)}}
{{$customBlock.security}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: security -=-= */

// Look up the content
require_once( {{$PACKAGE}}_PKG_PATH.'lookup_{{$type.name}}_inc.php' );

// Now check permissions to access this page
$gContent->verifyListViewPermission();

// Remove {{$type.name}} data if we don't want them anymore
if( isset( $_REQUEST["submit_mult"] ) && isset( $_REQUEST["checked"] ) && $_REQUEST["submit_mult"] == "remove_{{$type.name}}_data" ) {

	// Now check permissions to remove the selected {{$package}} data
	$gContent->verifyUserPermission( 'p_{{$type.name}}_expunge' );

	if( !empty( $_REQUEST['cancel'] ) ) {
		// user cancelled - just continue on, doing nothing
	} elseif( empty( $_REQUEST['confirm'] ) ) {
		$formHash['delete'] = TRUE;
		$formHash['submit_mult'] = 'remove_{{$type.name}}_data';
		foreach( $_REQUEST["checked"] as $del ) {
			$tmpInst = new {{$type.class_name}}($del);
			if ( $tmpInst->load() && !empty( $tmpInst->mInfo['title'] )) {
				$info = $tmpInst->mInfo['title'];
			} else {
				$info = $del;
			}
			$formHash['input'][] = '<input type="hidden" name="checked[]" value="'.$del.'"/>'.$info;
		}
		$gBitSystem->confirmDialog( $formHash,
			array(
				'label' => 'Remove '.$gContent->getContentTypeName( count( $_REQUEST["checked"] )>1 ),
				'warning' => tra('Are you sure you want to delete '.count( $_REQUEST["checked"] ).' '.$gContent->getContentTypeName( count( $_REQUEST["checked"] )>1  ).' records?'),
				'error' => tra('This cannot be undone!')
			)
		);
	} else {
		foreach( $_REQUEST["checked"] as $deleteId ) {
			$tmpInst = new {{$type.class_name}}( $deleteId );
			if( !$tmpInst->load() || !$tmpInst->expunge() ) {
				array_merge( $errors, array_values( $tmpInst->mErrors ) );
			}
		}
		if( !empty( $errors ) ) {
			$gBitSmarty->assign_by_ref( 'errors', $errors );
		}
	}
}

// Create new {{$type.class_name}} object
$obj = new {{$type.class_name}}();
$list = $obj->getList( $_REQUEST );
$gBitSmarty->assign_by_ref( '{{$type.name}}List', $list );

// getList() has now placed all the pagination information in $_REQUEST['listInfo']
$gBitSmarty->assign_by_ref( 'listInfo', $_REQUEST['listInfo'] );


/* =-=- CUSTOM BEGIN: list -=-= */
{{if !empty($customBlock.list)}}
{{$customBlock.list}}
{{else}}{{/if}}
/* =-=- CUSTOM END: list -=-= */


// Display the template
$gBitSystem->display( 'bitpackage:{{$package}}/list_{{$type.name}}.tpl', tra( $gContent->getContentTypeName( TRUE ) ) , array( 'display_mode' => 'list' ));


