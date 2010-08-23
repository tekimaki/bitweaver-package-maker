{strip}
{{include file="smarty_file_header.tpl}}
{form}
<input type="hidden" name="page" value="{$page}" />
	{jstabs}

	{{include file="home_settings_inc.tpl.tpl"}}

	{{include file="package_settings_inc.tpl.tpl"}}

	{{include file="type_settings_inc.tpl.tpl"}}

	{/jstabs}
{/form}
{/strip}
