{literal}<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{/literal}{include file="bitpackage:pkgmkr/php_file_header.tpl"}{literal}

/**
 * required setup
 */
require_once( '../kernel/setup_inc.php' );
include_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_{/literal}{$type.name}{literal}_inc.php' );

$gBitSystem->verifyPackage( '{/literal}{$package}{literal}' );

if( !$gContent->isValid() ) {
	$gBitSystem->fatalError( "No {/literal}{$type.name}{literal} indicated" );
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
$formHash['{/literal}{$type.name}{literal}_id'] = $_REQUEST['{/literal}{$type.name}{literal}_id'];
$msgHash = array(
	'label' => tra( 'Delete {/literal}{$type.name|capitalize}{literal}' ),
	'confirm_item' => $gContent->getTitle(),
	'warning' => tra( 'This {/literal}{$type.name}{literal} will be completely deleted.<br />This cannot be undone!' ),
);
$gBitSystem->confirmDialog( $formHash,$msgHash );

{/literal}
