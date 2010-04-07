{literal}<?php
{/literal}{include file="bitpackage:pkgmkr/php_file_header.tpl"}{literal}

$tables = array(
{/literal}{foreach from=$config.types key=typeName item=type}
	'{$typeName}_data' => "
{if $type.base_package == "liberty"}
		{$typeName}_id I4 PRIMARY,
		content_id I4 NOTNULL,
{/if}
{foreach from=$type.fields key=fieldName item=field name=fields}
                {$fieldName} {$field.schema.type}{if !empty($field.schema.notnull)} NOTNULL{/if}{if !empty($field.schema.default)} DEFAULT '{$field.schema.default}'{/if}{if !empty($field.schema.unique)} UNIQUE{/if}{if !$smarty.foreach.fields.last},{/if}

{/foreach}{if !empty($type.constraints) || $type.base_package == "liberty"}
	        CONSTRAINT '
{if $type.base_package == "liberty"}
                , CONSTRAINT `{$typeName}_content_ref` FOREIGN KEY (`content_id`) REFERENCES `liberty_content` (`content_id`)
{/if}
{foreach from=$type.constraints item=constraint}
		, CONSTRAINT {$constraint}
{/foreach}
		'
{/if}
	",
{/foreach}{literal}
);

global $gBitInstaller;

foreach( array_keys( $tables ) AS $tableName ) {
	$gBitInstaller->registerSchemaTable( {/literal}{$PACKAGE}{literal}_PKG_NAME, $tableName, $tables[$tableName] );
}

$gBitInstaller->registerPackageInfo( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
	'description' => "{/literal}{$config.description}{literal}",
	{/literal}{if $config.license}'license' => '{if $config.license.url}<a href="{$config.license.url}">{/if}{$config.license.name}{if $config.license.url}</a>{/if}',{/if}{literal}
));

// $indices = array();
// $gBitInstaller->registerSchemaIndexes( {/literal}{$PACKAGE}{literal}_PKG_NAME, $indices );

// Sequences
$gBitInstaller->registerSchemaSequences( {/literal}{$PACKAGE}{literal}_PKG_NAME, array (
{/literal}{foreach from=$config.types key=typeName item=type name=types}
	'{$typeName}_data_id_seq' => array( 'start' => 1 ){if !$smarty.foreach.types.last},{/if}
{/foreach}{literal}
));

// Schema defaults
$defaults = array(
{/literal}{foreach from=$config.types key=typeName item=type name=types}
{foreach from=$type.defaults item=default}
	"INSERT INTO `{$typeName}_data` {$default}"{if !$smarty.foreach.types.last},{/if}
{/foreach}{/foreach}{literal}
);
if (count($defaults) > 0) {
	$gBitInstaller->registerSchemaDefault( {/literal}{$PACKAGE}{literal}_PKG_NAME, $defaults);
}


// User Permissions
$gBitInstaller->registerUserPermissions( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
	array ( 'p_{/literal}{$package}{literal}_admin'  , 'Can admin the {/literal}{$package}{literal} package', 'admin'      , {/literal}{$PACKAGE}{literal}_PKG_NAME ),
{/literal}{foreach from=$config.types key=typeName item=type name=types}
	array ( 'p_{$typeName}_update' , 'Can update any {$typeName} entry' , 'editors'    , {$PACKAGE}_PKG_NAME ),
	array ( 'p_{$typeName}_create' , 'Can create a {$typeName} entry'   , 'registered' , {$PACKAGE}_PKG_NAME ),
	array ( 'p_{$typeName}_view'   , 'Can view {$typeName} entries'     , 'basic'      , {$PACKAGE}_PKG_NAME ),
	array ( 'p_{$typeName}_expunge', 'Can delete any {$typeName} entry' , 'admin'      , {$PACKAGE}_PKG_NAME ),
{/foreach}{literal}
));

// Default Preferences
$gBitInstaller->registerPreferences( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
{/literal}{foreach from=$config.types key=typeName item=type name=types}
	array ( {$PACKAGE}_PKG_NAME , '{$package}_{$typeName}_default_ordering'      , '{$typeName}_id_desc' ),
	array ( {$PACKAGE}_PKG_NAME , '{$package}_list_{$typeName}_id'               , 'y'              ),
	array ( {$PACKAGE}_PKG_NAME , '{$package}_{$typeName}_list_title'            , 'y'              ),
	array ( {$PACKAGE}_PKG_NAME , '{$package}_{$typeName}_list_summary'          , 'y'              ),
{if $config.homeable}
	array ( {$PACKAGE}_PKG_NAME , '{$package}_{$typeName}_home_id'               , 0                ),
{if $smarty.foreach.types.first}
	array ( {$PACKAGE}_PKG_NAME , '{$package}_home_type'                    , 'bit{$typeName}'      ),
{/if}
{/if}
{/foreach}{literal}
));

// Requirements
$gBitInstaller->registerRequirements( {/literal}{$PACKAGE}{literal}_PKG_NAME, array(
{/literal}{if empty($config.requirements)}
	'liberty' => array( 'min' => '2.1.0' )
{else}{foreach from=$config.requirements key=pkg item=reqs name=reqs}
	'{$pkg}' => array( {foreach from=$reqs key=k item=v name=values}'{$k}' => '{$v}'{if !$smarty.foreach.values.last},{/if}{/foreach} ){if !$smarty.foreach.reqs.last},{/if}
{/foreach}
{/if}
{literal}
));
{/literal}
