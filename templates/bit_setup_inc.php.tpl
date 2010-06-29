<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="bitpackage:pkgmkr/php_file_header.tpl"}}

global $gBitSystem;

$registerHash = array(
	'package_name' => '{{$package}}',
	'package_path' => dirname( __FILE__ ).'/',
	'homeable' => TRUE,
);
$gBitSystem->registerPackage( $registerHash );

// If package is active and the user has view auth then register the package menu
if( $gBitSystem->isPackageActive( '{{$package}}' ) && $gBitUser->hasPermission( 'p_{{$package}}_view' ) ) {
	$menuHash = array(
		'package_name'  => {{$PACKAGE}}_PKG_NAME,
		'index_url'     => {{$PACKAGE}}_PKG_URL.'index.php',
		'menu_template' => 'bitpackage:{{$package}}/menu_{{$package}}.tpl',
	);
	$gBitSystem->registerAppMenu( $menuHash );
}

