<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="bitpackage:pkgmkr/php_file_header.tpl"}}

/**
 * required setup
 */
require_once( '../kernel/setup_inc.php' );
include_once( {{$PACKAGE}}_PKG_PATH.'lookup_{{$type.name}}_inc.php' );

$gBitSystem->verifyPackage( '{{$package}}' );

if( !$gContent->isValid() ) {
	$gBitSystem->fatalError( "No {{$type.name}} indicated" );
}

$gContent->verifyExpungePermission();

if( isset( $_REQUEST["confirm"] ) ) {
	if( $gContent->expunge()  ) {
		header ("location: ".BIT_ROOT_URL );
		die;
	} else {
		$gBitSystem->fatalError( "Error while deleting: " + $gContent->mErrors );
	}
}

$gBitSystem->setBrowserTitle( tra( 'Confirm delete of: ' ).$gContent->getTitle() );
$formHash['remove'] = TRUE;
$formHash['{{$type.name}}_id'] = $_REQUEST['{{$type.name}}_id'];
$msgHash = array(
	'label' => tra( 'Delete {{$type.name|capitalize}}' ),
	'confirm_item' => $gContent->getTitle(),
	'warning' => tra( 'This {{$type.name}} will be completely deleted.<br />This cannot be undone!' ),
);
$gBitSystem->confirmDialog( $formHash,$msgHash );


