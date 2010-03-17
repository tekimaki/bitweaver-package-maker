{literal}<?php
/**
 * $Header: $
 *
 * Copyright (c) 2010 bitweaver.org
 * Copyright (c) 2010 nick palmer@overtsolutions.com
 *
 * All Rights Reserved. See below for details and a complete list of authors.
 * Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details
 *
 * $Id: $
 * @package {/literal}{$package}{literal}
 * @subpackage functions
 */

require_once( '../kernel/setup_inc.php' );
require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'Bit{/literal}{$Package}{literal}.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{/literal}{$package}{literal}' );

// Look up the content
require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_{/literal}{$package}{literal}_inc.php' );

// Now check permissions to access this page
$gContent->verifyViewPermission();

// Remove {/literal}{$package}{literal} data if we don't want them anymore
if( isset( $_REQUEST["submit_mult"] ) && isset( $_REQUEST["checked"] ) && $_REQUEST["submit_mult"] == "remove_{/literal}{$package}{literal}_data" ) {

	// Now check permissions to remove the selected {/literal}{$package}{literal} data
	$gBitSystem->verifyPermission( 'p_{/literal}{$package}{literal}_update' );

	if( !empty( $_REQUEST['cancel'] ) ) {
		// user cancelled - just continue on, doing nothing
	} elseif( empty( $_REQUEST['confirm'] ) ) {
		$formHash['delete'] = TRUE;
		$formHash['submit_mult'] = 'remove_{/literal}{$package}{literal}_data';
		foreach( $_REQUEST["checked"] as $del ) {
			$tmpPage = new Bit{/literal}{$Package}{literal}( $del);
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
			$tmpPage = new Bit{/literal}{$Package}{literal}( $deleteId );
			if( !$tmpPage->load() || !$tmpPage->expunge() ) {
				array_merge( $errors, array_values( $tmpPage->mErrors ) );
			}
		}
		if( !empty( $errors ) ) {
			$gBitSmarty->assign_by_ref( 'errors', $errors );
		}
	}
}

// Create new {/literal}{$package}{literal} object
${/literal}{$package}{literal} = new Bit{/literal}{$Package}{literal}();
${/literal}{$package}{literal}List = ${/literal}{$package}{literal}->getList( $_REQUEST );
$gBitSmarty->assign_by_ref( '{/literal}{$package}{literal}List', ${/literal}{$package}{literal}List );

// getList() has now placed all the pagination information in $_REQUEST['listInfo']
$gBitSmarty->assign_by_ref( 'listInfo', $_REQUEST['listInfo'] );

// Display the template
$gBitSystem->display( 'bitpackage:{/literal}{$package}{literal}/list_{/literal}{$package}{literal}.tpl', tra( '{/literal}{$Package}{literal}' ) , array( 'display_mode' => 'list' ));

{/literal}
