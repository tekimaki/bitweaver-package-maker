{strip}
{{include file="bitpackage:pkgmkr/smarty_file_header.tpl}}
<div class="floaticon">{bithelp}</div>

<div class="listing {{$package}} {{$type.name}}">
	<div class="header">
		<h1>{tr}{$gContent->getContentTypeName(TRUE)}{/tr}</h1>
	</div>

	<div class="body">
		{minifind sort_mode=$sort_mode}

		{form id="checkform"}
			<input type="hidden" name="offset" value="{$control.offset|escape}" />
			<input type="hidden" name="sort_mode" value="{$control.sort_mode|escape}" />

			<table class="data">
				<tr>
					{if $gBitSystem->isFeatureActive( '{{$package}}_list_{{$type.name}}_id' ) eq 'y'}
						<th>{smartlink ititle="{{$type.name|capitalize}} Id" isort={{$type.name}}_id offset=$control.offset iorder=desc idefault=1}</th>
					{/if}

					{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_title' ) eq 'y'}
						<th>{smartlink ititle="Title" isort=title offset=$control.offset}</th>
					{/if}


{{foreach from=$type.fields key=fieldName item=field name=fields}}
	 		     		{if $gBitSystem->isFeatureActive('{{$type.name}}_list_{{$fieldName}}' ) eq 'y'}
						<th>{smartlink ititle="{{$field.name|capitalize}}" isort={{$fieldName}} offset=$control.offset}</th>
					{/if}
{{/foreach}}


					{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_summary' ) eq 'y'}
						<th>{smartlink ititle="Text" isort=data offset=$control.offset}</th>
					{/if}

					<th>{tr}Actions{/tr}</th>
				</tr>

				{foreach item=dataItem from=${{$type.name}}List}
					<tr class="{cycle values="even,odd"}">
						{if $gBitSystem->isFeatureActive( 'list_{{$type.name}}_id' )}
							<td><a href="{$smarty.const.{{$PACKAGE}}_PKG_URL}index.php?{{$type.name}}_id={$dataItem.{{$type.name}}_id|escape:"url"}" title="{$dataItem.{{$type.name}}_id}">{$dataItem.{{$type.name}}_id}</a></td>
						{/if}

						{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_title' )}
							<td><a href="{$smarty.const.{{$PACKAGE}}_PKG_URL}index.php?{{$type.name}}_id={$dataItem.{{$type.name}}_id|escape:"url"}" title="{$dataItem.{{$type.name}}_id}">{$dataItem.title|escape}</a></td>
						{/if}


{{foreach from=$type.fields key=fieldName item=field name=fields}}
	 		     	     		{if $gBitSystem->isFeatureActive('{{$type.name}}_list_{{$fieldName}}' ) eq 'y'}
								<td>{$dataItem.{{$fieldName}}|{{if empty($field.validator.type)}}escape{{else}}{{if $field.validator.type == 'date'}}bit_short_date{{elseif $field.validator.type == 'time'}}bit_short_time{{elseif $field.validator.type == 'timestamp'}}bit_short_datetime{{else}}escape{{/if}}{{/if}}}</td>
						{/if}
{{/foreach}}


						{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_summary' )}
							<td>{$dataItem.summary|escape}</td>
						{/if}


						<td class="actionicon">
						{if $gBitUser->hasPermission( 'p_{{$package}}_{{$type.name}}_update' )}
							{smartlink ititle="Edit" ifile="edit_{{$type.name}}.php" ibiticon="icons/accessories-text-editor" {{$type.name}}_id=$dataItem.{{$type.name}}_id}
						{/if}
						{if $gBitUser->hasPermission( 'p_{{$package}}_{{$type.name}}_expunge' )}
							<input type="checkbox" name="checked[]" title="{$dataItem.title|escape}" value="{$dataItem.{{$type.name}}_id}" />
						{/if}
						</td>
					</tr>
				{foreachelse}
					<tr class="norecords"><td colspan="16">
						{tr}No records found{/tr}
					</td></tr>
				{/foreach}
			</table>

			{if $gBitUser->hasPermission( 'p_{{$package}}_{{$type.name}}_expunge' )}
				<div style="text-align:right;">
					<script type="text/javascript">/* <![CDATA[ check / uncheck all */
						document.write("<label for=\"switcher\">{tr}Select All{/tr}</label> ");
						document.write("<input name=\"switcher\" id=\"switcher\" type=\"checkbox\" onclick=\"BitBase.BitBase.switchCheckboxes(this.form.id,'checked[]','switcher')\" /><br />");
					/* ]]> */</script>

					<select name="submit_mult" onchange="this.form.submit();">
						<option value="" selected="selected">{tr}with checked{/tr}:</option>
						<option value="remove_{{$type.name}}_data">{tr}remove{/tr}</option>
					</select>

					<noscript><div><input type="submit" value="{tr}Submit{/tr}" /></div></noscript>
				</div>
			{/if}
		{/form}

		{pagination}
	</div><!-- end .body -->
</div><!-- end .listing -->
{/strip}

