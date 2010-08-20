<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim: :set fdm=marker : */
{{include file="php_file_header.tpl"}}

// If package is active and the user has view auth then register the package menu
if( $gBitSystem->isPackageActive( '{{$config.package}}' ) && $gBitUser->hasPermission( 'p_{{$config.package}}_view' ) ) {
// include service functions
{{foreach from=$config.typemap key=serviceName item=service}}
	require_once( CONFIG_PKG_PATH.'{{$config.package}}/plugins/{{$config.plugin}}/{{$service.class_name}}.php' );

	define( 'LIBERTY_SERVICE_{{$serviceName|strtoupper}}', '{{$service.type}}' );

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
{{/foreach}}

}

