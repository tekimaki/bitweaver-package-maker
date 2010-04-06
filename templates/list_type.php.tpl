{literal}<?php
{/literal}{include file="bitpackage:pkgmkr/file_header.tpl"}{literal}

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
	$gBitSystem->verifyPermission( 'p_{/literal}{$type.name}{literal}_expunge' );

	if( !empty( $_REQUEST['cancel'] ) ) {
		// user cancelled - just continue on, doing nothing
	} elseif( empty( $_REQUEST['confirm'] ) ) {
		$formHash['delete'] = TRUE;
		$formHash['submit_mult'] = 'remove_{/literal}{$package}{literal}_data';
		foreach( $_REQUEST["checked"] as $del ) {
			$tmpPage = new {/literal}{$type.class_name}{literal}($del);
			if ( $tmpPage->load() && !empty( $tmpPage->mInfo['title'] )) {
				$info = $tmpPage->mInfo['title'];
			} else {
				$info = $del;
			}
			$formHash['input'][] = '<input type="hidden" name="checked[]" value="'.$del.'"/>'.$info;
		}
		$gBitSystem->confirmDialog( $formHash, 
			array(
				'warning' => tra('Are you sure you want to delete ').count( $_REQUEST["checked"] ).' {/literal}{$package}{literal} records?',
				'error' => tra('This cannot be undone!')
			)
		);
	} else {
		foreach( $_REQUEST["checked"] as $deleteId ) {
			$tmpPage = new {/literal}{$type.class_name}{literal}( $deleteId );
			if( !$tmpPage->load() || !$tmpPage->expunge() ) {
				array_merge( $errors, array_values( $tmpPage->mErrors ) );
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
$gBitSystem->display( 'bitpackage:{/literal}{$package}/list_{$type.name}.tpl{literal}', tra( 'List {/literal}{$type.name|capitalize}{literal}' ) , array( 'display_mode' => 'list' ));

{/literal}
