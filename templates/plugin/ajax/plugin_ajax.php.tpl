<?php
// Initialization
// Depending on where the plugin lives we find kernel in one of two places
@include_once( '../../../../kernel/setup_inc.php' );
@include_once( '../../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{{$package}}' );

if( !empty( $_POST['req'] ) ){
    $gBitSmarty->assign( 'req', $_POST['req'] );
    switch( $_POST['req'] ){
{{foreach from=$config.typemaps item=typemap key=typemapName name=typemaps}}
{{foreach from=$typemap.fields item=field key=fieldName name=fields}}
{{if $field.input.type == "reference" }}
        case 'fetch_{{$typemapName}}_{{$fieldName}}_list':
            ${{$config.class_name}} = new {{$config.class_name}}();
            $options = ${{$config.class_name}}->get{{$typemapName|ucfirst}}{{$field.name|default:$fieldName|replace:" ":""|ucfirst}}Options($_POST);
            $gBitSmarty->assign_by_ref( '{{$fieldName}}_options', $options );
            $gBitSmarty->assign( '{{$fieldName}}_search', $_POST['{{$fieldName}}_search'] );
            break;
{{/if}}
{{/foreach}}
{{/foreach}}
        default:
            $gBitSmarty->assign('error', tra("Invalid Request"));
    }
} else {
  $gBitSmarty->assign('error', tra("Invalid Request"));
}

$gBitSystem->display('bitpackage:{{$package}}{{if !empty($plugin)}}/{{$plugin}}/plugin_{{/if}}ajax.tpl', null, array( 'format' => 'center_only', 'display_mode' => 'edit' ));
die;

