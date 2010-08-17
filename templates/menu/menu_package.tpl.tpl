{strip}
{{include file="bitpackage:pkgmkr/smarty_file_header.tpl}}
	<ul>
		{if $gBitUser->hasPermission( 'p_{{$package}}_view')}
			<li><a class="item" href="{$smarty.const.{{$PACKAGE}}_PKG_URL}index.php">{tr}{{$Package}} Home{/tr}</a></li>

{{foreach from=$config.types key=typeName item=type name=types}}

			{if $gBitUser->hasPermission( 'p_{{$typeName}}_view')}
				<li><a class="item" href="{$smarty.const.{{$PACKAGE}}_PKG_URL}list_{{$typeName}}.php">{tr}List {{if $type.content_name_plural}}{{$type.content_name_plural}}{{else}}{{$type.content_name}} Data{{/if}}{/tr}</a></li>
			{/if}

{{/foreach}}

		{/if}

{{foreach from=$config.types key=typeName item=type name=types}}

		{if $gBitUser->hasPermission( 'p_{{$typeName}}_create')}
		<li><a class="item" href="{$smarty.const.{{$PACKAGE}}_PKG_URL}edit_{{$typeName}}.php">{tr}Create {{$type.content_name}}{/tr}</a></li>
		{/if}

{{/foreach}}

	</ul>
{/strip}
