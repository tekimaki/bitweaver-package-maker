<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim: :set fdm=marker : */
{{include file="php_file_header.tpl"}}

global $gBitSystem, $gBitUser, $gLibertySystem;

define( 'LIBERTY_SERVICE_{{$config.name|strtoupper}}', '{{$config.plugin}}' );

// If package is active and the user has view auth then register the package menu
if( $gBitSystem->isPackageActive( '{{$config.package}}' ) ){ //&& $gBitUser->hasPermission( 'p_{{$config.package}}_view' ) ) {
}
/* =-=- CUSTOM BEGIN: setup_plugin -=-= */
{{if !empty($customBlock.setup_plugin)}}
{{$customBlock.setup_plugin}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: setup_plugin -=-= */


