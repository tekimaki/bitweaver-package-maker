<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="php_file_header.tpl"}}

$tables = array(
{{foreach from=$config.typemaps key=typemapName item=typemap}}
    {{include file="typemap_schema_inc.php.tpl" tablePrefix=$config.name}}
{{/foreach}}
{{foreach from=$config.tables key=tableName item=table}}
    {{include file="table_schema_inc.php.tpl" tableName=$tableName table=$table}}
{{/foreach}}
);

global $gBitInstaller;

foreach( array_keys( $tables ) AS $tableName ) {
	$gBitInstaller->registerSchemaTable( {{$PACKAGE}}_PKG_NAME, $tableName, $tables[$tableName] );
}

// $indices = array();
// $gBitInstaller->registerSchemaIndexes( {{$PACKAGE}}_PKG_NAME, $indices );

// Sequences
$gBitInstaller->registerSchemaSequences( {{$PACKAGE}}_PKG_NAME, array (
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.sequence}}
	'{{$config.name}}_{{$typemapName}}_id_seq' => array( 'start' => 1 ),
{{/if}}
{{/foreach}}
));

// Schema defaults
$defaults = array(
{{foreach from=$config.typemaps key=typemapName item=typemap name=typemaps}}
{{foreach from=$typemap.defaults item=default}}
	"INSERT INTO `{{$typemapName}}_data` {{$default}}"{{if !$smarty.foreach.typemaps.last}},{{/if}}
{{/foreach}}{{/foreach}}
);
if (count($defaults) > 0) {
	$gBitInstaller->registerSchemaDefault( {{$PACKAGE}}_PKG_NAME, $defaults);
}

// User Permissions
$gBitInstaller->registerUserPermissions( {{$PACKAGE}}_PKG_NAME, array(
{{foreach from=$config.typemaps key=typemapName item=typemap name=typemaps}}
	array ( 'p_{{$typemapName}}_service_create' , 'Can create a {{$typemapName}} entry'   , '{{$typemap.permissions.default.create|default:registered}}' , {{$PACKAGE}}_PKG_NAME ),
	array ( 'p_{{$typemapName}}_service_view'   , 'Can view {{$typemapName}} entries'     , '{{$typemap.permissions.default.view|default:basic}}'      , {{$PACKAGE}}_PKG_NAME ),
	array ( 'p_{{$typemapName}}_service_update' , 'Can update any {{$typemapName}} entry' , '{{$typemap.permissions.default.update|default:editors}}'    , {{$PACKAGE}}_PKG_NAME ),
	array ( 'p_{{$typemapName}}_service_expunge', 'Can delete any {{$typemapName}} entry' , '{{$typemap.permissions.default.expunge|default:admin}}'      , {{$PACKAGE}}_PKG_NAME ),
	array ( 'p_{{$typemapName}}_service_admin'  , 'Can admin any {{$typemapName}} entry'  , '{{$typemap.permissions.default.admin|default:admin}}'      , {{$PACKAGE}}_PKG_NAME ),
{{/foreach}}
));

// Service Preferences
{{* currently passes guid as string - cant assume constants are defined - since they are defined in classes*}}
{{foreach from=$config.content_types item=ctypes}}
$gBitInstaller->registerServicePreferences( {{$PACKAGE}}_PKG_NAME, '{{$config.type}}', array( {{foreach from=$ctypes item=ctype}}'{{$ctype}}',{{/foreach}}) );
{{/foreach}}

// Requirements
/* add the time of generation of this package there is no means for plugins to add requirements */
