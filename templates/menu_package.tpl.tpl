{literal}{strip}
{/literal}{include file="bitpackage:pkgmkr/smarty_file_header.tpl}{literal}
	<ul>
		{if $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_view')}
			<li><a class="item" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}index.php">{tr}{/literal}{$Package}{literal} Home{/tr}</a></li>
{/literal}
{foreach from=$config.types key=typeName item=type name=types}
{literal}
			{if $gBitUser->hasPermission( 'p_{/literal}{$typeName}{literal}_view')}
				<li><a class="item" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}list_{/literal}{$typeName}{literal}.php">{tr}List {/literal}{if $type.content_name_plural}{$type.content_name_plural}{else}{$type.content_name} Data{/if}{literal}{/tr}</a></li>
			{/if}
{/literal}
{/foreach}
{literal}
		{/if}
{/literal}
{foreach from=$config.types key=typeName item=type name=types}
{literal}
		{if $gBitUser->hasPermission( 'p_{/literal}{$typeName}{literal}_create')}
		<li><a class="item" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}edit_{/literal}{$typeName}{literal}.php">{tr}Create {/literal}{$type.content_name}{literal}{/tr}</a></li>
		{/if}
{/literal}
{/foreach}
{literal}
	</ul>
{/strip}{/literal}
