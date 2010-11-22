{{foreach from=$config.services.sql key=func item=typemaps}}
function {{$config.name}}_{{$func}}( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
{{if $func eq 'content_load_sql'}}
{{include file="plugin_content_load_sql.php.tpl"}}
{{elseif $func eq 'content_list_sql'}}
{{include file="plugin_content_list_sql.php.tpl"}}
{{/if}}
	}
}
{{/foreach}}
{{foreach from=$config.services.functions key=func item=typemaps}}
function {{$config.name}}_{{$func}}( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
{{if $func eq 'content_display'}}
{{include file="plugin_content_display.php.tpl"}}
{{elseif $func eq 'content_edit'}}
{{include file="slideshow_content_edit.php.tpl"}}
{{elseif $func eq 'content_expunge'}}
{{include file="plugin_content_expunge.php.tpl"}}
{{elseif $func eq 'content_load'}}
{{include file="plugin_content_load.php.tpl"}}
{{elseif $func eq 'content_preview'}}
{{include file="plugin_content_preview.php.tpl"}}
{{elseif $func eq 'content_store'}}
{{include file="plugin_content_store.php.tpl"}}
{{elseif $func eq 'upload_expunge_attachment'}}
{{include file="plugin_upload_expunge_attachment.php.tpl"}}
{{elseif $func eq 'upload_expunge'}}
{{include file="plugin_upload_expunge.php.tpl"}}
{{elseif $func eq 'upload_store'}}
{{include file="plugin_upload_store.php.tpl"}}
{{else}}
{{include file=$func|cat:'.php.tpl'}}
{{/if}} 
	}
}
{{/foreach}}

{{include file="slideshow_content_section.php.tpl"}}

{{include file="package_admin.php.tpl"}}
