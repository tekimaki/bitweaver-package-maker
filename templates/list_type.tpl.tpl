{literal}{strip}
{/literal}{include file="bitpackage:pkgmkr/smarty_file_header.tpl}{literal}
<div class="floaticon">{bithelp}</div>

<div class="listing {/literal}{$package} {$type.name}{literal}">
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

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_list_{$type.name}_id{literal}' ) eq 'y'}
						<li>{smartlink ititle="{/literal}{$type.name|capitalize}{literal} Id" isort={/literal}{$type.name}_id{literal} offset=$control.offset iorder=desc idefault=1}</li>
					{/if}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_title{literal}' ) eq 'y'}
						<li>{smartlink ititle="Title" isort=title offset=$control.offset}</li>
					{/if}

{/literal}
{foreach from=$type.fields key=fieldName item=field name=fields}
	 		     		{ldelim}if $gBitSystem->isFeatureActive('{$package}_{$type.name}_list_{$fieldName}' ) eq 'y'{rdelim}
						<li>{ldelim}smartlink ititle="{$field.name|capitalize}" isort={$fieldName} offset=$control.offset{rdelim}</li>
					{ldelim}/if{rdelim}
{/foreach}
{literal}

					{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_summary{literal}' ) eq 'y'}
						<li>{smartlink ititle="Text" isort=data offset=$control.offset}</li>
					{/if}
				</ul>
			</div>

			<ul class="data clear">
				{foreach item=dataItem from=${/literal}{$type.name}{literal}List name={/literal}{$type.name}{literal}list}
					<li class="{if $smarty.foreach.{/literal}{$type.name}{literal}list.last}last {/if}{cycle values="even,odd"}">
						<div class="floaticon">
							{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$type.name}_update{literal}' )}
								{smartlink ititle="Edit" ifile="{/literal}edit_{$type.name}.php{literal}" ibiticon="icons/accessories-text-editor" {/literal}{$type.name}_id=$dataItem.{$type.name}_id{literal}}
							{/if}
							{if $gBitUser->hasPermission( 'p_{/literal}{$package}_{$type.name}_expunge{literal}' )}
								<input type="checkbox" name="checked[]" title="{$dataItem.title|escape}" value="{$data_item.{/literal}{$type.name}_id{literal}}" />
							{/if}
						</div>

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_title{literal}' )}
							<h2><a href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}index.php?{/literal}{$type.name}_id{literal}={$dataItem.{/literal}{$type.name}{literal}_id|escape:"url"}" title="{$dataItem.{/literal}{$type.name}{literal}_id}">{$dataItem.title|escape}</a></h2>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_{$type.name}_list_summary{literal}' )}
							<div>{$dataItem.summary|escape}</div>
						{/if}

						{if $gBitSystem->isFeatureActive( '{/literal}{$package}_list_{$type.name}_id{literal}' )}
							<label>{/literal}{$type.name|ucfirst}_id{literal}:</label>&nbsp;<a href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}index.php?{/literal}{$type.name}_id{literal}={$dataItem.{/literal}{$type.name}{literal}_id|escape:"url"}" title="{$dataItem.{/literal}{$type.name}{literal}_id}">{$dataItem.{/literal}{$type.name}{literal}_id}</a><br />
						{/if}

{/literal}
{foreach from=$type.fields key=fieldName item=field name=fields}
	 		     	    {ldelim}if $gBitSystem->isFeatureActive('{$package}_{$type.name}_list_{$fieldName}' ) eq 'y'{rdelim}
							<label>{$field.name}:</label>&nbsp;{ldelim}$dataItem.{$fieldName}|{if empty($field.validator.type)}escape{else}{if $field.validator.type == 'date'}bit_short_date{elseif $field.validator.type == 'time'}bit_short_time{elseif $field.validator.type == 'timestamp'}bit_short_datetime{else}escape{/if}{/if}{rdelim}<br />
						{ldelim}/if{rdelim}
{/foreach}
{literal}

					</li>
				{foreachelse}
					<li class="norecords">{tr}No records found{/tr}</li>
				{/foreach}
			</ul>

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
