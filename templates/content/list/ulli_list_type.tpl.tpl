{strip}
{{include file="smarty_file_header.tpl}}
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

			<div class="navbar">
				<ul>
					<li><strong>{tr}Sort list by:{/tr} </strong></li>

					{if $gBitSystem->isFeatureActive( '{{$package}}_list_{{$type.name}}_id' ) eq 'y'}
						<li>{smartlink ititle="{{$type.name|capitalize}} Id" isort={{$type.name}}_id offset=$control.offset iorder=desc idefault=1}</li>
					{/if}

{{if $type.title}}

					{if $gBitSystem->isFeatureActive('{{$type.name}}_list_title') eq 'y'}
						<li>{smartlink ititle="{{$type.fields.title.name|default:'Title'}}" isort=title offset=$control.offset}</li>
					{/if}

{{/if}}
{{foreach from=$type.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'title'}}
	 		     	{if $gBitSystem->isFeatureActive('{{$type.name}}_list_{{$fieldName}}' ) eq 'y'}
						<li>{smartlink ititle="{{$field.name|capitalize}}" isort={{$fieldName}} offset=$control.offset}</li>
					{/if}
{{/if}}
{{/foreach}}


					{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_summary' ) eq 'y'}
						<li>{smartlink ititle="Text" isort=data offset=$control.offset}</li>
					{/if}
				</ul>
			</div>

			<ul class="data clear">
				{foreach item=dataItem from=${{$type.name}}List name={{$type.name}}list}
					<li class="{if $smarty.foreach.{{$type.name}}list.last}last {/if}{cycle values="even,odd"}">
						<div class="floaticon">
							{if $gBitUser->hasPermission( 'p_{{$type.name}}_update' )}
								{smartlink ititle="Edit" ifile="edit_{{$type.name}}.php" ibiticon="icons/accessories-text-editor" {{$type.name}}_id=$dataItem.{{$type.name}}_id}
							{/if}
							{if $gBitUser->hasPermission( 'p_{{$type.name}}_expunge' )}
								<input type="checkbox" name="checked[]" title="{$dataItem.title|escape}" value="{$dataItem.{{$type.name}}_id}" />
							{/if}
						</div>

{{if $type.title}}

						{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_title' )}
							<h2><a href="{$smarty.const.{{$PACKAGE}}_PKG_URL}index.php?{{$type.name}}_id={$dataItem.{{$type.name}}_id|escape:"url"}" title="{$dataItem.{{$type.name}}_id}">{$dataItem.title|escape}</a></h2>
						{/if}

{{/if}}
{{if $type.summary}}

						{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_summary' )}
							<div class="summary">{$dataItem.summary|escape}</div>
						{/if}

{{/if}}
{{if $type.data}}

						{if $gBitSystem->isFeatureActive( '{{$type.name}}_list_data' )}
							<div class="body">{$dataItem.parsed_data}</div>
						{/if}

{{/if}}
<ul>

						{if $gBitSystem->isFeatureActive( '{{$package}}_list_{{$type.name}}_id' )}
							<li><label>{{$type.name|ucfirst}}_id:</label>&nbsp;<a href="{$smarty.const.{{$PACKAGE}}_PKG_URL}index.php?{{$type.name}}_id={$dataItem.{{$type.name}}_id|escape:"url"}" title="{$dataItem.{{$type.name}}_id}">{$dataItem.{{$type.name}}_id}</a></li>
						{/if}

{{foreach from=$type.fields key=fieldName item=field name=fields}}{{if $fieldName != 'data' && $fieldName != 'summary'}}
	 		     	    {if $gBitSystem->isFeatureActive('{{$type.name}}_list_{{$fieldName}}' ) eq 'y'}
							<li><label>{{$field.name}}:</label>&nbsp;{$dataItem.{{$fieldName}}|{{if empty($field.validator.type)}}escape{{else}}{{if $field.validator.type == 'date'}}bit_short_date{{elseif $field.validator.type == 'time'}}bit_short_time{{elseif $field.validator.type == 'timestamp'}}bit_short_datetime{{else}}escape{{/if}}{{/if}}}</li>
						{/if}
{{/if}}{{/foreach}}
</ul>


					</li>
				{foreachelse}
					<li class="norecords">{tr}No records found{/tr}</li>
				{/foreach}
			</ul>

			{if $gBitUser->hasPermission( 'p_{{$type.name}}_expunge' )}
				<div style="text-align:right;">
					<script type="text/javascript">/* <![CDATA[ check / uncheck all */
						document.write("<label for=\"switcher\">{tr}Select All{/tr}</label> ");
						document.write("<input name=\"switcher\" id=\"switcher\" type=\"checkbox\" onclick=\"BitBase.BitBase.switchCheckboxes(this.form.id,'checked[]','switcher')\" /><br />");
					/* ]]> */</script>

					<select name="submit_mult" onchange="this.form.submit();">
						<option value="" selected="selected">{tr}with checked{/tr}:</option>
						<option value="remove_{{$type.name}}_data">{tr}remove{/tr}</option>
					</select>

					<noscript><div><input class="button" type="submit" value="{tr}Submit{/tr}" /></div></noscript>
				</div>
			{/if}
		{/form}

		{pagination}
	</div><!-- end .body -->
</div><!-- end .listing -->
{/strip}

