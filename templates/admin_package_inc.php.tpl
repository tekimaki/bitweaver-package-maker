{literal}<?php
{/literal}{include file="bitpackage:pkgmkr/file_header.tpl"}{literal}

{/literal}{foreach from=$config.types key=typeName item=type name=types}
require_once( {$PACKAGE}_PKG_PATH.'{$type.class_name}.php' );

$form{$typeName}Lists = array(
	"{$package}_list_{$typeName}_id" => array(
		'label' => 'Id',
		'note' => 'Display the {$typeName} id.',
	),
	"{$package}_{$typeName}_list_title" => array(
		'label' => 'Title',
		'note' => 'Display the title.',
	),
{foreach from=$type.fields key=fieldName item=field name=fields}
        "{$package}_{$typeName}_list_{$fieldName}" => array(
                'label' => '{$fieldName|capitalize}',
		'note' => 'Display the {$fieldName}',
	),
{/foreach}
	"{$package}_{$typeName}_list_summary" => array(
		'label' => 'Text',
		'note' => 'Display the summary.',
	),
);
$gBitSmarty->assign( 'form{$typeName}Lists', $form{$typeName}Lists );
{/foreach}{literal}

// Process the form if we've made some changes
if( !empty( $_REQUEST['{/literal}{$package}{literal}_settings'] )) {
	${/literal}{$package}{literal}Toggles = array_merge( 
{/literal}{foreach from=$config.types key=typeName item=type name=types}
		$form{$typeName}Lists{if !$smarty.foreach.types.last},{/if}
{/foreach}{literal}
	);
	foreach( ${/literal}{$package}{literal}Toggles as $item => $data ) {
		simple_set_toggle( $item, {/literal}{$PACKAGE}{literal}_PKG_NAME );
	}
{/literal}{if $config.homeable}
{foreach from=$config.types key=typeName item=type name=types}
	simple_set_int( '{$package}_{$typeName}_home_id', {$PACKAGE}_PKG_NAME );
{/foreach}
	simple_set_value( '{$package}_home_type', {$PACKAGE}_PKG_NAME );
{/if}{literal}
}
{/literal}{if $config.homeable}
// We require all records for home selection menu
// TODO: These should be selected with ajax magic instead
$_REQUEST['max_records'] = 0;

{foreach from=$config.types key=typeName item=type name=types}

$obj = new {$type.class_name}();
$obj_data = $obj->getList( $_REQUEST );
$gBitSmarty->assign_by_ref( '{$typeName}_data', $obj_data);

$gBitSmarty->assign( '{$package}_{$typeName}_home_id', 
	$gBitSystem->getConfig( "{$package}_{$typeName}_home_id" ));

{/foreach}

$gBitSmarty->assign( '{$package}_home_type', 
	$gBitSystem->getConfig( "{$package}_home_type" ));
$gBitSmarty->assign( 'homeTypes', array(
{foreach from=$config.types key=typeName item=type name=types}
		'{$typeName}'{if !$smarty.foreach.types.last},{/if}
{/foreach}
	));
{/if}
