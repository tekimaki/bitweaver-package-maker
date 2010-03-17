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

/**
 * required setup
 */
require_once( '../kernel/setup_inc.php' );
include_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'Bit{/literal}{$Package}{literal}.php');
include_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_{/literal}{$package}{literal}_inc.php' );

$gBitSystem->verifyPackage( '{/literal}{$package}{literal}' );

if( !$gContent->isValid() ) {
	$gBitSystem->fatalError( "No {/literal}{$package}{literal} indicated" );
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
$formHash['sample_id'] = $_REQUEST['sample_id'];
$msgHash = array(
	'label' => tra( 'Delete {/literal}{$Package}{literal}' ),
	'confirm_item' => $gContent->getTitle(),
	'warning' => tra( 'This {/literal}{$package}{literal} will be completely deleted.<br />This cannot be undone!' ),
);
$gBitSystem->confirmDialog( $formHash,$msgHash );

{/literal}