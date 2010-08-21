<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim: :set fdm=marker : */
{{include file="php_file_header.tpl"}}

// If package is active and the user has view auth then register the package menu
if( $gBitSystem->isPackageActive( '{{$config.package}}' ) && $gBitUser->hasPermission( 'p_{{$config.package}}_view' ) ) {
	// service functions
	require_once( CONFIG_PKG_PATH.'{{$config.package}}/plugins/{{$config.plugin}}/{{$service.class_name}}.php' );

	define( 'LIBERTY_SERVICE_{{$config.name|strtoupper}}', '{{$config.type}}' );

    $gLibertySystem->registerService(
		LIBERTY_SERVICE_{{$config.name|strtoupper}},
		{{$PACKAGE}}_PKG_NAME,
        array(
{{foreach from=$config.services key=func item=typemaps}}
			'{{$func}}_function' => '{{$config.name}}_{{$func}}',
{{/foreach}}
        ),
        array(
			'description' => '{{$config.description}}'
        )
    );
}

