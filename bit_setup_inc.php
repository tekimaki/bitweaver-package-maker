<?php
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
 * @package pkgmaker.php
 * @subpackage functions
 */

global $gBitSystem;

$registerHash = array(
	'package_name' => 'pkgmkr',
	'package_path' => dirname( __FILE__ ).'/',
	'homeable' => TRUE,
);
$gBitSystem->registerPackage( $registerHash );

// If package is active and the user has view auth then register the package menu
if( $gBitSystem->isPackageActive( 'pkgmkr' ) && $gBitUser->hasPermission( 'p_pkgmkr_view' ) ) {
	$menuHash = array(
		'package_name'  => PKGMKR_PKG_NAME,
		'index_url'     => PKGMKR_PKG_URL.'index.php',
		'menu_template' => 'bitpackage:pkgmkr/menu_pkgmkr.tpl',
	);
	$gBitSystem->registerAppMenu( $menuHash );
}
?>
