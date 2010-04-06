{literal}<?php
{/literal}{include file="bitpackage:pkgmkr/file_header.tpl"}{literal}

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
