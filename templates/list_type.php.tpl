{literal}<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{/literal}{include file="bitpackage:pkgmkr/php_file_header.tpl"}{literal}

require_once( '../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{/literal}{$package}{literal}' );

// Look up the content
require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_{/literal}{$type.name}{literal}_inc.php' );

// Now check permissions to access this page
$gContent->verifyViewPermission();

// Remove {/literal}{$type.name}{literal} data if we don't want them anymore
if( isset( $_REQUEST["submit_mult"] ) && isset( $_REQUEST["checked"] ) && $_REQUEST["submit_mult"] == "remove_{/literal}{$type.name}{literal}_data" ) {

	// Now check permissions to remove the selected {/literal}{$package}{literal} data
	$gContent->verifyUserPermission( 'p_{/literal}{$type.name}{literal}_expunge' );

	if( !empty( $_REQUEST['cancel'] ) ) {
		// user cancelled - just continue on, doing nothing
	} elseif( empty( $_REQUEST['confirm'] ) ) {
		$formHash['delete'] = TRUE;
		$formHash['submit_mult'] = 'remove_{/literal}{$type.name}{literal}_data';
		foreach( $_REQUEST["checked"] as $del ) {
			$tmpInst = new {/literal}{$type.class_name}{literal}($del);
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
			$tmpInst = new {/literal}{$type.class_name}{literal}( $deleteId );
			if( !$tmpInst->load() || !$tmpInst->expunge() ) {
				array_merge( $errors, array_values( $tmpInst->mErrors ) );
			}
		}
		if( !empty( $errors ) ) {
			$gBitSmarty->assign_by_ref( 'errors', $errors );
		}
	}
}

// Create new {/literal}{$type.class_name}{literal} object
$obj = new {/literal}{$type.class_name}{literal}();
$list = $obj->getList( $_REQUEST );
$gBitSmarty->assign_by_ref( '{/literal}{$type.name}{literal}List', $list );

// getList() has now placed all the pagination information in $_REQUEST['listInfo']
$gBitSmarty->assign_by_ref( 'listInfo', $_REQUEST['listInfo'] );

// Display the template
$gBitSystem->display( 'bitpackage:{/literal}{$package}/list_{$type.name}.tpl{literal}', tra( 'List '.$gContent->getContentTypeName( TRUE ) ) , array( 'display_mode' => 'list' ));

{/literal}
