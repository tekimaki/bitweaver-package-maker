{literal}{strip}
	<ul>
		{if $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_view')}
			<li><a class="item" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}index.php">{tr}{/literal}{$Package}{literal} Home{/tr}</a></li>
			<li><a class="item" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}list_{/literal}{$package}{literal}.php">{tr}List {/literal}{$Package}{literal} Data{/tr}</a></li>
		{/if}
		{if $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_create' )}
			<li><a class="item" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}edit.php">{tr}Create {/literal}{$Package}{literal}{/tr}</a></li>
		{/if}
	</ul>
{/strip}{/literal}
