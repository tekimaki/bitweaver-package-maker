<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="bitpackage:pkgmkr/php_file_header.tpl"}}

global $gContent;
require_once( {{$PACKAGE}}_PKG_PATH.'{{$type.class_name}}.php');
//require_once( LIBERTY_PKG_PATH.'lookup_content_inc.php' );

// if we already have a gContent, we assume someone else created it for us, and has properly loaded everything up.
if( empty( $gContent ) || !is_object( $gContent ) || !$gContent->isValid() ) {
	// if {{$type.name}}_id supplied, use that
	if( @BitBase::verifyId( $_REQUEST['{{$type.name}}_id'] ) ) {
		$gContent = new {{$type.class_name}}( $_REQUEST['{{$type.name}}_id'] );

	// if content_id supplied, use that
	} elseif( @BitBase::verifyId( $_REQUEST['content_id'] ) ) {
		$gContent = new {{$type.class_name}}( NULL, $_REQUEST['content_id'] );

	} elseif (@BitBase::verifyId( $_REQUEST['{{$package}}']['{{$type.name}}_id'] ) ) {
		$gContent = new {{$type.class_name}}( $_REQUEST['{{$package}}']['{{$type.name}}_id'] );

	// otherwise create new object
	} else {
		$gContent = new {{$type.class_name}}();
	}

	$gContent->load();
	$gBitSmarty->assign_by_ref( "gContent", $gContent );
}

