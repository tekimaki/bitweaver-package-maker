{{foreach from=$config.services.functions key=func item=typemaps}}
function {{$config.name}}_{{$func}}( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
{{if $func eq 'comment_store'}}
{{include file="comment_store.php.tpl"}}
{{elseif $func eq 'commerce_post_purchase'}}
{{include file="commerce_post_purchase.php.tpl"}}
{{elseif $func eq 'commerce_pre_purchase'}}
{{include file="commerce_pre_purchase.php.tpl"}}
{{elseif $func eq 'content_display'}}
{{include file="content_display.php.tpl"}}
{{elseif $func eq 'content_edit'}}
{{include file="content_edit.php.tpl"}}
{{elseif $func eq 'content_expunge'}}
{{include file="content_expunge.php.tpl"}}
{{elseif $func eq 'content_list_history'}}
{{include file="content_list_history.php.tpl"}}
{{elseif $func eq 'content_list'}}
{{include file="content_list.php.tpl"}}
{{elseif $func eq 'content_load'}}
{{include file="content_load.php.tpl"}}
{{elseif $func eq 'content_preview'}}
{{include file="content_preview.php.tpl"}}
{{elseif $func eq 'content_store'}}
{{include file="content_store.php.tpl"}}
{{elseif $func eq 'content_user_perms'}}
{{include file="content_user_perms.php.tpl"}}
{{elseif $func eq 'content_verify_access'}}
{{include file="content_verify_access.php.tpl"}}
{{elseif $func eq 'upload_expunge_attachment'}}
{{include file="upload_expunge_attachment.php.tpl"}}
{{elseif $func eq 'upload_expunge'}}
{{include file="upload_expunge.php.tpl"}}
{{elseif $func eq 'upload_store'}}
{{include file="upload_store.php.tpl"}}
{{elseif $func eq 'user_register'}}
{{include file="user_register.php.tpl"}}
{{elseif $func eq 'content_load_sql'}}
{{include file="content_load_sql.php.tpl"}}
{{elseif $func eq 'content_list_sql'}}
{{include file="content_list_sql.php.tpl"}}
{{/if}}
	}
}
{{/foreach}}

{{include file="content_section.php.tpl"}}

{{include file="package_admin.php.tpl"}}
