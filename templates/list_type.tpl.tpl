{literal}{strip}
<div class="floaticon">{bithelp}</div>

<div class="listing {/literal}{$package} {$render.class}{literal}">
	<div class="header">
		<h1>{tr}{/literal}{$render.class|capitalize}{literal} Records{/tr}</h1>
	</div>

	<div class="body">
		{minifind sort_mode=$sort_mode}

		{form id="checkform"}
			<input type="hidden" name="offset" value="{$control.offset|escape}" />
			<input type="hidden" name="sort_mode" value="{$control.sort_mode|escape}" />

			<table class="data">
				<tr>
					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_list_{$render.class}_id{literal}' ) eq 'y'}
						<th>{smartlink ititle="{/literal}{$render.class|capitalize}{literal} Id" isort={/literal}{$render.class}_id{literal} offset=$control.offset iorder=desc idefault=1}</th>
					{/if}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$render.class}__list_title{literal}' ) eq 'y'}
						<th>{smartlink ititle="Title" isort=title offset=$control.offset}</th>
					{/if}

					TODO: other list fields here!

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$render.class}_list_summary{literal}' ) eq 'y'}
						<th>{smartlink ititle="Text" isort=data offset=$control.offset}</th>
					{/if}

					<th>{tr}Actions{/tr}</th>
				</tr>

				{foreach item={/literal}{$render.class}{literal} from=${/literal}{$render.class}{literal}List}
					<tr class="{cycle values="even,odd"}">
						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_list_{$render.class}_id{literal}' )}
							<td><a href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}index.php?{/literal}{$render.class}_id{literal}={${/literal}{$render.class}{literal}.{/literal}{$render.class}{literal}_id|escape:"url"}" title="{${/literal}{$render.class}{literal}.{/literal}{$render.class}{literal}_id}">{${/literal}{$render.class}{literal}.{/literal}{$render.class}{literal}_id}</a></td>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$render.class}_list_title{literal}' )}
							<td>{${/literal}{$render.class}{literal}.title|escape}</td>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$render.class}_list_summary{literal}' )}
							<td>{${/literal}{$package}{literal}.summary|escape}</td>
						{/if}


						<td class="actionicon">
						{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$render.class}_update{literal}' )}
							{smartlink ititle="Edit" ifile="{/literal}edit_{$render.class}.php{literal}" ibiticon="icons/accessories-text-editor" {/literal}{$render.class}_id=${$render.class}.{$render.class}_id{literal}}
						{/if}
						{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$render.class}_expunge{literal}' )}
							<input type="checkbox" name="checked[]" title="{${/literal}{$render.class}{literal}.title|escape}" value="{${/literal}{$render.class}.{$render.class}_id{literal}}" />
						{/if}
						</td>
					</tr>
				{foreachelse}
					<tr class="norecords"><td colspan="16">
						{tr}No records found{/tr}
					</td></tr>
				{/foreach}
			</table>

			{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$render.class}_expunge{literal}' )}
				<div style="text-align:right;">
					<script type="text/javascript">/* <![CDATA[ check / uncheck all */
						document.write("<label for=\"switcher\">{tr}Select All{/tr}</label> ");
						document.write("<input name=\"switcher\" id=\"switcher\" type=\"checkbox\" onclick=\"BitBase.BitBase.switchCheckboxes(this.form.id,'checked[]','switcher')\" /><br />");
					/* ]]> */</script>

					<select name="submit_mult" onchange="this.form.submit();">
						<option value="" selected="selected">{tr}with checked{/tr}:</option>
						<option value="remove_{/literal}{$render.class}{literal}_data">{tr}remove{/tr}</option>
					</select>

					<noscript><div><input type="submit" value="{tr}Submit{/tr}" /></div></noscript>
				</div>
			{/if}
		{/form}

		{pagination}
	</div><!-- end .body -->
</div><!-- end .listing -->
{/strip}
{/literal}