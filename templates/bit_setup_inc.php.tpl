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

global $gBitSystem;

$registerHash = array(
	'package_name' => '{/literal}{$package}{literal}',
	'package_path' => dirname( __FILE__ ).'/',
	'homeable' => TRUE,
);
$gBitSystem->registerPackage( $registerHash );

// If package is active and the user has view auth then register the package menu
if( $gBitSystem->isPackageActive( '{/literal}{$package}{literal}' ) && $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_view' ) ) {
	$menuHash = array(
		'package_name'  => {/literal}{$PACKAGE}{literal}_PKG_NAME,
		'index_url'     => {/literal}{$PACKAGE}{literal}_PKG_URL.'index.php',
		'menu_template' => 'bitpackage:{/literal}{$package}{literal}/menu_{/literal}{$package}{literal}.tpl',
	);
	$gBitSystem->registerAppMenu( $menuHash );
}
{/literal}