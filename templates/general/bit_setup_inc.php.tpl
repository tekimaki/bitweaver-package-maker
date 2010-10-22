<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="php_file_header.tpl"}}
{{foreach from=$config.services key=serviceName item=service}}
define( 'LIBERTY_SERVICE_{{$serviceName|strtoupper}}', '{{$service.type}}' );
{{/foreach}}

global $gBitSystem;

$registerHash = array(
	'package_name' => '{{$package}}',
	'package_path' => dirname( __FILE__ ).'/',
	'homeable' => TRUE,
);
$gBitSystem->registerPackage( $registerHash );

// If package is active and the user has view auth then register the package menu
if( $gBitSystem->isPackageActive( '{{$package}}' ) ){ //&& $gBitUser->hasPermission( 'p_{{$package}}_view' ) ) {
	$menuHash = array(
		'package_name'  => {{$PACKAGE}}_PKG_NAME,
		'index_url'     => {{$PACKAGE}}_PKG_URL.'index.php',
{{if $config.types}}
		'menu_template' => 'bitpackage:{{$package}}/menu_{{$package}}.tpl',
{{/if}}
	);
	$gBitSystem->registerAppMenu( $menuHash );

{{if $config.services}}
    // include service functions
{{foreach from=$config.services key=serviceName item=service}}
	require_once( {{$PACKAGE}}_PKG_PATH.'{{$service.class_name}}.php' );

	/*
    $gLibertySystem->registerService(
		LIBERTY_SERVICE_{{$serviceName|strtoupper}},
		{{$PACKAGE}}_PKG_NAME,
        array(
{{foreach from=$service.functions item=func}}
			'{{$func}}_function' => '{{$serviceName}}_{{$func}}',
{{/foreach}}
        ),
        array(
			'description' => '{{$service.description}}'
        )
    );
	*/
{{/foreach}}
{{/if}}

{{if $config.pluggable}}
$gLibertySystem->loadPackagePlugins( {{$PACKAGE}}_PKG_NAME );
{{/if}}

}

