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

require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_{/literal}{$type.name}{literal}_inc.php' );

// Now check permissions to access this page
if( $gContent->isValid() ){
	$gContent->verifyUpdatePermission();
}else{
	$gContent->verifyCreatePermission();
}

// TODO: Move these! They should not be here
if( isset( $_REQUEST['{/literal}{$type.name}{literal}']["title"] ) ) {
	$gContent->mInfo["title"] = $_REQUEST['{/literal}{$type.name}{literal}']["title"];
}

if( isset( $_REQUEST['{/literal}{$package}{literal}']["description"] ) ) {
	$gContent->mInfo["description"] = $_REQUEST['{/literal}{$type.name}{literal}']["description"];
}

if( isset( $_REQUEST["format_guid"] ) ) {
	$gContent->mInfo['format_guid'] = $_REQUEST["format_guid"];
}

if( isset( $_REQUEST['{/literal}{$type.name}{literal}']["edit"] ) ) {
	$gContent->mInfo["data"] = $_REQUEST['{/literal}{$type.name}{literal}']["edit"];
	$gContent->mInfo['parsed_data'] = $gContent->parseData();
}

// If we are in preview mode then preview it!
if( isset( $_REQUEST["preview"] ) ) {
	// TODO: prepare preview here?
	$gContent->invokeServices( 'content_preview_function' );
} else {
	$gContent->invokeServices( 'content_edit_function' );
}

// Pro
// Check if the page has changed
if( !empty( $_REQUEST["save_{/literal}{$type.name}{literal}"] ) ) {

	// Check if all Request values are delivered, and if not, set them
	// to avoid error messages. This can happen if some features are
	// disabled
	if( $gContent->store( $_REQUEST['{/literal}{$type.name}{literal}'] ) ) {
		header( "Location: ".$gContent->getDisplayUrl() );
		die;
	} else {
		$gBitSmarty->assign_by_ref( 'errors', $gContent->mErrors );
	}
}

// Display the template
$gBitSystem->display( 'bitpackage:{/literal}{$package}{literal}/edit_{/literal}{$type.name}{literal}.tpl', tra('Edit {/literal}{$type.name|capitalize}{literal}') , array( 'display_mode' => 'edit' ));

{/literal}
