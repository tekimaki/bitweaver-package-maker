{{* admin settings handlers *}}
{{if $config.settings}}
function {{$config.name}}_package_admin( &$pParamHash ){
    include_once( CONFIG_PKG_PATH.'{{$package}}/plugins/{{$config.name}}/admin_plugin_inc.php' );
}
{{/if}}
