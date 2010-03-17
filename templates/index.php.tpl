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

// Initialization
require_once( '../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{/literal}{$package}{literal}' );

// Check permissions to access this page before even try to get content
$gBitSystem->verifyPermission( 'p_{/literal}{$package}{literal}_view' );

// Get the default content if none is requested 
if( !isset( $_REQUEST['{/literal}{$package}{literal}_id'] ) ) {
	$_REQUEST['{/literal}{$package}{literal}_id'] = $gBitSystem->getConfig( "{/literal}{$package}{literal}_home_id" );
}

// If there is a {/literal}{$package}{literal} id to get, specified or default, then attempt to get it and display
if( !empty( $_REQUEST['{/literal}{$package}{literal}_id'] ) ) {
	// Look up the content
	require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_{/literal}{$package}{literal}_inc.php' );

	if( !$gContent->isValid() ) {
		$gBitSystem->setHttpStatus( 404 );
		$gBitSystem->fatalError( tra( "The requested {/literal}{$package}{literal} (id=".$_REQUEST['{/literal}{$package}{literal}_id'].") could not be found." ) );
	}

	// Now check permissions to access this content 
	$gContent->verifyViewPermission();

	// Add a hit to the counter
	$gContent->addHit();

	// Display the template
	$gBitSystem->display( 'bitpackage:{/literal}{$package}{literal}/display_{/literal}{$package}{literal}.tpl', tra( '{/literal}{$Package}{literal}' ) , array( 'display_mode' => 'display' ));

} else if ( $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_admin' ) ) {
    // Redirect to det up the default {/literal}{$package}{literal} data to display
	header( "Location: ".KERNEL_PKG_URL.'admin/index.php?page='.{/literal}{$PACKAGE}{literal}_PKG_NAME );

} else {
	$gBitSystem->setHttpStatus( 404 );
	$gBitSystem->fatalError( tra( "The default {/literal}{$package}{literal} data has not been configured." ) );
}

{/literal}