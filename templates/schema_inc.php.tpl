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
 * @subpackage schema
 */

$tables = array(
	'{/literal}{$package}{literal}_data' => "
		{/literal}{$package}{literal}_id I4 PRIMARY,
		content_id I4 NOTNULL,
		description C(160)
	",
);

global $gBitInstaller;

foreach( array_keys( $tables ) AS $tableName ) {
	$gBitInstaller->registerSchemaTable( {/literal}{$PACKAGE}{literal}_PKG_NAME, $tableName, $tables[$tableName] );
}

$gBitInstaller->registerPackageInfo( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
	'description' => "{/literal}{$Package}{literal} package to demonstrate how to build a bitweaver package.",
	'license' => '<a href="http://www.gnu.org/licenses/licenses.html#LGPL">LGPL</a>',
));

// $indices = array();
// $gBitInstaller->registerSchemaIndexes( ARTICLES_PKG_NAME, $indices );

// Sequences
$gBitInstaller->registerSchemaSequences( {/literal}{$PACKAGE}{literal}_PKG_NAME, array (
	'{/literal}{$package}{literal}_data_id_seq' => array( 'start' => 1 )
));

/* // Schema defaults
$gBitInstaller->registerSchemaDefault( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
	"INSERT INTO `".BIT_DB_PREFIX."bit_{/literal}{$package}{literal}_types` (`type`) VALUES ('{/literal}{$Package}{literal}')",
)); */

// User Permissions
$gBitInstaller->registerUserPermissions( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
	array ( 'p_{/literal}{$package}{literal}_admin'  , 'Can admin {/literal}{$package}{literal}'           , 'admin'      , {/literal}{$PACKAGE}{literal}_PKG_NAME ),
	array ( 'p_{/literal}{$package}{literal}_update' , 'Can update any {/literal}{$package}{literal} entry', 'editors'    , {/literal}{$PACKAGE}{literal}_PKG_NAME ),
	array ( 'p_{/literal}{$package}{literal}_create' , 'Can create a {/literal}{$package}{literal} entry'  , 'registered' , {/literal}{$PACKAGE}{literal}_PKG_NAME ),
	array ( 'p_{/literal}{$package}{literal}_view'   , 'Can view {/literal}{$package}{literal} data'       , 'basic'      , {/literal}{$PACKAGE}{literal}_PKG_NAME ),
	array ( 'p_{/literal}{$package}{literal}_expunge', 'Can delete any {/literal}{$package}{literal} entry', 'admin'      , {/literal}{$PACKAGE}{literal}_PKG_NAME ),
));

// Default Preferences
$gBitInstaller->registerPreferences( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
	array ( {/literal}{$PACKAGE}{literal}_PKG_NAME , '{/literal}{$package}{literal}_default_ordering' , '{/literal}{$package}{literal}_id_desc' ),
	array ( {/literal}{$PACKAGE}{literal}_PKG_NAME , '{/literal}{$package}{literal}_list_{/literal}{$package}{literal}_id'   , 'y'              ),
	array ( {/literal}{$PACKAGE}{literal}_PKG_NAME , '{/literal}{$package}{literal}_list_title'       , 'y'              ),
	array ( {/literal}{$PACKAGE}{literal}_PKG_NAME , '{/literal}{$package}{literal}_list_description' , 'y'              ),
	array ( {/literal}{$PACKAGE}{literal}_PKG_NAME , '{/literal}{$package}{literal}_home_id'          , 0                ),
));

// Version - now use upgrades dir to set package version number.
// $gBitInstaller->registerPackageVersion( {/literal}{$PACKAGE}{literal}_PKG_NAME, '0.5.1' );

// Requirements
$gBitInstaller->registerRequirements( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
	'liberty' => array( 'min' => '2.1.0' ),
));
{/literal}
