<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="php_file_header.tpl"}}

global $gBitSmarty;

{{* Plugin Settings *}}
{{if $config.settings}}
{{foreach from=$config.settings key=pkgSettingsName item=pkgSettingGroup name=pkgSettings}}
$form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}} = array(
{{foreach from=$pkgSettingGroup key=settingName item=settings name=settingsGroup}}
	"{{$config.plugin}}_{{$settingName}}" => array(
		'label' => '{{$settings.label}}',
		'note' => '{{$settings.note}}',
		'type' => '{{if $settings.type eq string}}input{{else}}{{$settings.type|default:'toggle'}}{{/if}}',
		{{if $settings.default}}'default' => '{{if $settings.type eq boolean}}y{{else}}{{$settings.default}}{{/if}}',{{/if}}
	),
{{/foreach}}
);
$gBitSmarty->assign( 'form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}}', $form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}} );
{{/foreach}}

// Process the form if we've made some changes
if( !empty( $_REQUEST['{{$config.plugin}}_settings'] ) ){
{{foreach from=$config.settings key=pkgSettingsName item=pkgSettingGroup name=pkgSettings}}
	simple_set_configs(  $form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}}, {{$PACKAGE}}_PKG_NAME );
{{/foreach}}
}
{{/if}}
{{* End Plugin Settings *}}

{{* hexcolor *}}
{{assign var=jsColorIncluded value=false}}
{{foreach from=$typemap.fields item=data key=field name=fields}}
{{if !empty($data.validator.type) && $data.validator.type == 'hexcolor' && !$jsColorIncluded}}
{{assign var=jsColorIncluded value=true}}
// hexcolor library
global $gBitThemes;
$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/jscolor/jscolor.js', FALSE );
{{/if}}
{{/foreach}}

