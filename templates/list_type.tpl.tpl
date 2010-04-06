{literal}{strip}
<div class="floaticon">{bithelp}</div>

<div class="listing {/literal}{$package} {$type.name}{literal}">
	<div class="header">
		<h1>{tr}{/literal}{$type.name|capitalize}{literal} Records{/tr}</h1>
	</div>

	<div class="body">
		{minifind sort_mode=$sort_mode}

		{form id="checkform"}
			<input type="hidden" name="offset" value="{$control.offset|escape}" />
			<input type="hidden" name="sort_mode" value="{$control.sort_mode|escape}" />

			<table class="data">
				<tr>
					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_list_{$type.name}_id{literal}' ) eq 'y'}
						<th>{smartlink ititle="{/literal}{$type.name|capitalize}{literal} Id" isort={/literal}{$type.name}_id{literal} offset=$control.offset iorder=desc idefault=1}</th>
					{/if}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_title{literal}' ) eq 'y'}
						<th>{smartlink ititle="Title" isort=title offset=$control.offset}</th>
					{/if}

{/literal}
{foreach from=$type.fields key=fieldName item=field name=fields}
	 		     		{ldelim}if $gBitSystem->isFeatureActive('{$package}_{$type.name}_list_{$fieldName}' ) eq 'y'{rdelim}
						<th>{ldelim}smartlink ititle="{$field.name|capitalize}" isort={$fieldName} offset=$control.offset{rdelim}</th>
					{ldelim}/if{rdelim}
{/foreach}
{literal}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_summary{literal}' ) eq 'y'}
						<th>{smartlink ititle="Text" isort=data offset=$control.offset}</th>
					{/if}

					<th>{tr}Actions{/tr}</th>
				</tr>

				{foreach item=dataItem from=${/literal}{$type.name}{literal}List}
					<tr class="{cycle values="even,odd"}">
						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_list_{$type.name}_id{literal}' )}
							<td><a href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}index.php?{/literal}{$type.name}_id{literal}={$dataItem.{/literal}{$type.name}{literal}_id|escape:"url"}" title="{$dataItem.{/literal}{$type.name}{literal}_id}">{$dataItem.{/literal}{$type.name}{literal}_id}</a></td>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_title{literal}' )}
							<td>{$dataItem.title|escape}</td>
						{/if}

{/literal}
{foreach from=$type.fields key=fieldName item=field name=fields}
	 		     	     		{ldelim}if $gBitSystem->isFeatureActive('{$pacakge}_{$type.name}_list_{$fieldName}' ) eq 'y'{rdelim}
							   <td>{ldelim}$dataItem.{$fieldName}|{if empty($field.validator.type)}escape{else}{if $field.validator.type == 'date'}bit_short_date{elseif $field.validator.type == 'time'}bit_short_time{elseif $field.validator.type == 'timestamp'}bit_short_datetime{else}escape{/if}{/if}</td>
						{ldelim}/if{rdelim}
{/foreach}
{literal}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_summary{literal}' )}
							<td>{$dataItem.summary|escape}</td>
						{/if}


						<td class="actionicon">
						{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$type.name}_update{literal}' )}
							{smartlink ititle="Edit" ifile="{/literal}edit_{$type.name}.php{literal}" ibiticon="icons/accessories-text-editor" {/literal}{$type.name}_id=${$type.name}.{$type.name}_id{literal}}
						{/if}
						{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$type.name}_expunge{literal}' )}
							<input type="checkbox" name="checked[]" title="{$dataItem.title|escape}" value="{${/literal}{$type.name}.{$type.name}_id{literal}}" />
						{/if}
						</td>
					</tr>
				{foreachelse}
					<tr class="norecords"><td colspan="16">
						{tr}No records found{/tr}
					</td></tr>
				{/foreach}
			</table>

			{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$type.name}_expunge{literal}' )}
				<div style="text-align:right;">
					<script type="text/javascript">/* <![CDATA[ check / uncheck all */
						document.write("<label for=\"switcher\">{tr}Select All{/tr}</label> ");
						document.write("<input name=\"switcher\" id=\"switcher\" type=\"checkbox\" onclick=\"BitBase.BitBase.switchCheckboxes(this.form.id,'checked[]','switcher')\" /><br />");
					/* ]]> */</script>

					<select name="submit_mult" onchange="this.form.submit();">
						<option value="" selected="selected">{tr}with checked{/tr}:</option>
						<option value="remove_{/literal}{$type.name}{literal}_data">{tr}remove{/tr}</option>
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