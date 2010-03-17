{literal}{strip}
<div class="floaticon">{bithelp}</div>

<div class="listing {/literal}{$package}{literal}">
	<div class="header">
		<h1>{tr}{/literal}{$Package}{literal} Records{/tr}</h1>
	</div>

	<div class="body">
		{minifind sort_mode=$sort_mode}

		{form id="checkform"}
			<input type="hidden" name="offset" value="{$control.offset|escape}" />
			<input type="hidden" name="sort_mode" value="{$control.sort_mode|escape}" />

			<table class="data">
				<tr>
					{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_{/literal}{$package}{literal}_id' ) eq 'y'}
						<th>{smartlink ititle="{/literal}{$Package}{literal} Id" isort={/literal}{$package}{literal}_id offset=$control.offset iorder=desc idefault=1}</th>
					{/if}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_title' ) eq 'y'}
						<th>{smartlink ititle="Title" isort=title offset=$control.offset}</th>
					{/if}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_description' ) eq 'y'}
						<th>{smartlink ititle="Description" isort=description offset=$control.offset}</th>
					{/if}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_data' ) eq 'y'}
						<th>{smartlink ititle="Text" isort=data offset=$control.offset}</th>
					{/if}

					<th>{tr}Actions{/tr}</th>
				</tr>

				{foreach item={/literal}{$package}{literal} from=${/literal}{$package}{literal}List}
					<tr class="{cycle values="even,odd"}">
						{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_{/literal}{$package}{literal}_id' )}
							<td><a href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}index.php?{/literal}{$package}{literal}_id={${/literal}{$package}{literal}.{/literal}{$package}{literal}_id|escape:"url"}" title="{${/literal}{$package}{literal}.{/literal}{$package}{literal}_id}">{${/literal}{$package}{literal}.{/literal}{$package}{literal}_id}</a></td>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_title' )}
							<td>{${/literal}{$package}{literal}.title|escape}</td>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_description' )}
							<td>{${/literal}{$package}{literal}.description|escape}</td>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}{literal}_list_data' )}
							<td>{${/literal}{$package}{literal}.data|escape}</td>
						{/if}

						<td class="actionicon">
						{if $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_update' )}
							{smartlink ititle="Edit" ifile="edit.php" ibiticon="icons/accessories-text-editor" {/literal}{$package}{literal}_id=${/literal}{$package}{literal}.{/literal}{$package}{literal}_id}
						{/if}
						{if $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_expunge' )}
							<input type="checkbox" name="checked[]" title="{${/literal}{$package}{literal}.title|escape}" value="{${/literal}{$package}{literal}.{/literal}{$package}{literal}_id}" />
						{/if}
						</td>
					</tr>
				{foreachelse}
					<tr class="norecords"><td colspan="16">
						{tr}No records found{/tr}
					</td></tr>
				{/foreach}
			</table>

			{if $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_expunge' )}
				<div style="text-align:right;">
					<script type="text/javascript">/* <![CDATA[ check / uncheck all */
						document.write("<label for=\"switcher\">{tr}Select All{/tr}</label> ");
						document.write("<input name=\"switcher\" id=\"switcher\" type=\"checkbox\" onclick=\"BitBase.BitBase.switchCheckboxes(this.form.id,'checked[]','switcher')\" /><br />");
					/* ]]> */</script>

					<select name="submit_mult" onchange="this.form.submit();">
						<option value="" selected="selected">{tr}with checked{/tr}:</option>
						<option value="remove_{/literal}{$package}{literal}_data">{tr}remove{/tr}</option>
					</select>

					<noscript><div><input type="submit" value="{tr}Submit{/tr}" /></div></noscript>
				</div>
			{/if}
		{/form}

		{pagination}
	</div><!-- end .body -->
</div><!-- end .admin -->
{/strip}
{/literal}