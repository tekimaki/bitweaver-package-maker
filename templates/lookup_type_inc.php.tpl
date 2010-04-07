{literal}<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{/literal}{include file="bitpackage:pkgmkr/php_file_header.tpl"}{literal}

global $gContent;
require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'{/literal}{$type.class_name}{literal}.php');
//require_once( LIBERTY_PKG_PATH.'lookup_content_inc.php' );

// if we already have a gContent, we assume someone else created it for us, and has properly loaded everything up.
if( empty( $gContent ) || !is_object( $gContent ) || !$gContent->isValid() ) {
	// if {/literal}{$type.name}{literal}_id supplied, use that
	if( @BitBase::verifyId( $_REQUEST['{/literal}{$type.name}{literal}_id'] ) ) {
		$gContent = new {/literal}{$type.class_name}{literal}( $_REQUEST['{/literal}{$type.name}{literal}_id'] );

	// if content_id supplied, use that
	} elseif( @BitBase::verifyId( $_REQUEST['content_id'] ) ) {
		$gContent = new {/literal}{$type.class_name}{literal}( NULL, $_REQUEST['content_id'] );

	} elseif (@BitBase::verifyId( $_REQUEST['{/literal}{$package}{literal}']['{/literal}{$type.name}{literal}_id'] ) ) {
		$gContent = new {/literal}{$type.class_name}{literal}( $_REQUEST['{/literal}{$package}{literal}']['{/literal}{$type.name}{literal}_id'] );

	// otherwise create new object
	} else {
		$gContent = new {/literal}{$type.class_name}{literal}();
	}

	$gContent->load();
	$gBitSmarty->assign_by_ref( "gContent", $gContent );
}
{/literal}
