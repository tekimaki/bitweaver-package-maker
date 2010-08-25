<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="php_file_header.tpl"}}


{{* Package Settings *}}
{{if $config.settings}}
{{foreach from=$config.settings key=pkgSettingsName item=pkgSettingGroup name=pkgSettings}}
$form{{$pkgSettingsName|ucfirst}} = array(
{{foreach from=$pkgSettingGroup key=settingName item=settings name=settingsGroup}}
	"{{$package}}_{{$settingName}}" => array(
		'label' => '{{$settings.label}}',
		'note' => '{{$settings.note}}',
		'type' => '{{if $settings.type eq numeric}}numeric{{elseif $settings.type eq string}}input{{else}}toggle{{/if}}',
		{{if $settings.default}}'default' => '{{if $settings.type eq boolean}}y{{else}}{{$settings.default}}{{/if}}',{{/if}}
	),
{{/foreach}}
);
$gBitSmarty->assign( 'form{{$pkgSettingsName|ucfirst}}', $form{{$pkgSettingsName|ucfirst}} );
{{/foreach}}
{{/if}}
{{* End Package Settings *}}


{{* Type Settings *}}
{{foreach from=$config.types key=typeName item=type name=types}}
require_once( {{$PACKAGE}}_PKG_PATH.'{{$type.class_name}}.php' );

{{* List Settings *}}
$form{{$typeName}}Lists = array(
	"{{$package}}_list_{{$typeName}}_id" => array(
		'label' => 'Id',
		'note' => 'Display the {{$typeName}} id.',
	),
{{if $type.title}}
	"{{$typeName}}_list_title" => array(
		'label' => '{{$type.fields.title.name|default:'Title'}}',
		'note' => 'Display the {{$type.fields.title.name|default:'title'|strtolower}}.',
	),
{{/if}}
{{if $type.summary}}
	"{{$typeName}}_list_summary" => array(
		'label' => '{{$type.fields.summary.name|default:'Summary'|capitalize}}',
		'note' => 'Display the {{$type.fields.summary.name|default:'summary'|strtolower}}.',
	),
{{/if}}
{{if $type.data}}
	"{{$typeName}}_list_data" => array(
		'label' => '{{$type.fields.data.name|default:'Body Text'|capitalize}}',
		'note' => 'Display the {{$type.fields.data.name|default:'body'|strtolower}} text.',
	),
{{/if}}
{{foreach from=$type.fields key=fieldName item=field name=fields}}{{if $fieldName != 'data' && $fieldName != 'summary' && $fieldName != 'title'}}
        "{{$typeName}}_list_{{$fieldName}}" => array(
		'label' => '{{$field.name|default:$fieldName|capitalize}}',
		'note' => 'Display the {{$fieldName}}',
	),
{{/if}}{{/foreach}}
);
$gBitSmarty->assign( 'form{{$typeName}}Lists', $form{{$typeName}}Lists );
{{* End List Settings *}}

{{* Defined Type Settings *}}
{{if $type.settings}}
{{foreach from=$type.settings key=typeSettingsName item=typeSettingsGroup name=typeSettings}}
$form{{$typeName|ucfirst}}{{$typeSettingsName|ucfirst}} = array(
{{foreach from=$typeSettingsGroup key=settingName item=settings name=settingsGroup}}
	"{{$typeName}}_{{$settingName}}" => array(
		'label' => '{{$settings.label}}',
		'note' => '{{$settings.note}}',
		'type' => '{{if $settings.type eq numeric}}numeric{{elseif $settings.type eq string}}input{{else}}toggle{{/if}}',
	),
{{/foreach}}
);
$gBitSmarty->assign( 'form{{$typeName|ucfirst}}{{$typeSettingsName|ucfirst}}', $form{{$typeName|ucfirst}}{{$typeSettingsName|ucfirst}} );
{{/foreach}}
{{/if}}
{{* End Defined Type Settings *}}

{{/foreach}}
{{* End Type Settings *}}



// Process the form if we've made some changes
if( !empty( $_REQUEST['{{$package}}_settings'] ) ){

{{if $config.settings}}
{{foreach from=$config.settings key=pkgSettingsName item=pkgSettingGroup name=pkgSettings}}
	simple_set_configs(  $form{{$pkgSettingsName|ucfirst}}, {{$PACKAGE}}_PKG_NAME );
{{/foreach}}
{{/if}}

{{foreach from=$config.types key=typeName item=type name=types}}
{{if $type.settings}}
{{foreach from=$type.settings key=typeSettingsName item=typeSettingsGroup name=typeSettings}}
	simple_set_configs(  $form{{$typeName|ucfirst}}{{$typeSettingsName|ucfirst}}, {{$PACKAGE}}_PKG_NAME );
{{/foreach}}
{{/if}}
{{/foreach}}

{{if $config.types}}
	${{$package}}Toggles = array_merge( 
{{foreach from=$config.types key=typeName item=type name=types}}
		$form{{$typeName}}Lists{{if !$smarty.foreach.types.last}},{{/if}}
{{/foreach}}
	);
	foreach( ${{$package}}Toggles as $item => $data ) {
		simple_set_toggle( $item, {{$PACKAGE}}_PKG_NAME );
	}
{{/if}}
{{if $config.homeable}}
{{foreach from=$config.types key=typeName item=type name=types}}
	simple_set_int( '{{$package}}_{{$typeName}}_home_id', {{$PACKAGE}}_PKG_NAME );
{{/foreach}}
	simple_set_value( '{{$package}}_home_type', {{$PACKAGE}}_PKG_NAME );
{{/if}}
}




{{if $config.homeable}}
// We require all records for home selection menu
// TODO: These should be selected with ajax magic instead
$_REQUEST['max_records'] = 0;

{{foreach from=$config.types key=typeName item=type name=types}}

$obj = new {{$type.class_name}}();
$obj_data = $obj->getList( $_REQUEST );
$gBitSmarty->assign_by_ref( '{{$typeName}}_data', $obj_data);

$gBitSmarty->assign( '{{$package}}_{{$typeName}}_home_id', 
	$gBitSystem->getConfig( "{{$package}}_{{$typeName}}_home_id" ));

{{/foreach}}

$gBitSmarty->assign( '{{$package}}_home_type', 
	$gBitSystem->getConfig( "{{$package}}_home_type" ));
$gBitSmarty->assign( 'homeTypes', array(
{{foreach from=$config.types key=typeName item=type name=types}}
		'{{$typeName}}'{{if !$smarty.foreach.types.last}},{{/if}}
{{/foreach}}
	));
{{/if}}

{{if $config.pluggable}}
// invoke content admin services
{{foreach from=$config.types key=typeName item=type name=types}}
${{$type.class_name}} = new {{$type.class_name}}();
${{$type.class_name}}->invokeServices( 'content_admin_function', $_REQUEST );
{{/foreach}}
{{/if}}

