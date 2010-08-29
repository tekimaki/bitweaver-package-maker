<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="php_file_header.tpl"}}

{{* Plugin Settings *}}
{{if $config.settings}}
{{foreach from=$config.settings key=pkgSettingsName item=pkgSettingGroup name=pkgSettings}}
$form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}} = array(
{{foreach from=$pkgSettingGroup key=settingName item=settings name=settingsGroup}}
	"{{$config.plugin}}_{{$settingName}}" => array(
		'label' => '{{$settings.label}}',
		'note' => '{{$settings.note}}',
		'type' => '{{if $settings.type eq numeric}}numeric{{elseif $settings.type eq string}}input{{else}}toggle{{/if}}',
		{{if $settings.default}}'default' => '{{if $settings.type eq boolean}}y{{else}}{{$settings.default}}{{/if}}',{{/if}}
	),
{{/foreach}}
);
$gBitSmarty->assign( 'form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}}', $form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}} );
{{/foreach}}
{{/if}}
{{* End Plugin Settings *}}

