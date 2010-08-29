{strip}
{{include file="smarty_file_header.tpl}}
{form}
<input type="hidden" name="page" value="{$page}" />
	{jstabs}

	{{include file="home_settings_inc.tpl.tpl"}}

	{{include file="package_settings_inc.tpl.tpl"}}

	{{include file="type_settings_inc.tpl.tpl"}}

	{{if $config.pluggable}}
		{include file="bitpackage:liberty/service_package_admin_inc.tpl" package=$smarty.const.{{$PACKAGE}}_PKG_NAME }
	{{/if}}

	{/jstabs}
{/form}
{/strip}
