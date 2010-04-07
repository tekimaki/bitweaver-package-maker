{literal}{strip}
{/literal}{include file="smarty_file_header.tpl}{literal}
{form}
	{jstabs}
{* Are there homeable settings? *}
{/literal}{if $config.homeable}{literal}
		{jstab title="{/literal}{$Package}{literal} Home Settings"}
			{legend legend="{/literal}{$Package}{literal} Home Settings"}
				<input type="hidden" name="page" value="{$page}" />
				<div class="row">
					{formlabel label="{/literal}{$Package}{literal} Home Type"}
					{forminput}
						<select name="{/literal}{$package}{literal}_home_type" id="home{/literal}{$Package}{literal}">
							{section name=ix loop=$homeTypes}
								<option value="{$homeTypes[ix]|escape}" {if ${/literal}{$package}{literal}_home_type == $homeTypes[ix]}selected="selected"{/if} >{$homeTypes[ix]}</option>
							{/section}
						</select>
					{/forminput}
				</div>		
{* Output for each type *}
{/literal}{foreach from=$config.types key=typeName item=type name=types}{literal}
				<div class="row">
					{formlabel label="Home {/literal}{$typeName|capitalize}{literal}" for="home{/literal}{$typeName|capitalize}{literal}"}
					{forminput}
						<select name="{/literal}{$package}_{$typeName}{literal}_home_id" id="home{/literal}{$typeName|capitalize}{literal}">
							{section name=ix loop=${/literal}{$typeName}{literal}_data}
								<option value="{${/literal}{$typeName}{literal}_data[ix].{/literal}{$typeName}{literal}_id|escape}" {if ${/literal}{$typeName}{literal}_data[ix].{/literal}{$typeName}{literal}_id eq ${/literal}{$package}_{$typeName}{literal}_home_id}selected="selected"{/if}>{${/literal}{$typeName}{literal}_data[ix].title|escape|truncate:20:"...":true}</option>
							{sectionelse}
								<option>{tr}No records found{/tr}</option>
							{/section}
						</select>
						{formhelp note="This is the {/literal}{$typeName}{literal} that will be displayed when viewing the {/literal}{$package}{literal} homepage if {/literal}{$Package}{literal} Home Type above is set to {/literal}{$typeName}{literal}"}
					{/forminput}
				</div>
{* End foreach type *}
{/literal}{/foreach}{literal}
			{/legend}
			<div class="row submit">
				<input type="submit" name="{/literal}{$package}{literal}_settings" value="{tr}Change preferences{/tr}" />
			</div>
		{/jstab}
{* End homeable section *}
{/literal}{/if}{literal}

{* For Each Type Offer Home Selection *}
{/literal}{foreach from=$config.types key=typeName item=type name=types}{literal}
		{jstab title="{/literal}{$typeName|capitalize}{literal} List Settings"}
			{legend legend="{/literal}{$typeName|capitalize}{literal} List Settings"}
				<input type="hidden" name="page" value="{$page}" />
				{foreach from=$form{/literal}{$typeName}{literal}Lists key=item item=output}
					<div class="row">
						{formlabel label=`$output.label` for=$item}
						{forminput}
							{html_checkboxes name="$item" values="y" checked=$gBitSystem->getConfig($item) labels=false id=$item}
							{formhelp note=`$output.note` page=`$output.page`}
						{/forminput}
					</div>
				{/foreach}
			{/legend}
			<div class="row submit">
				<input type="submit" name="{/literal}{$package}{literal}_settings" value="{tr}Change preferences{/tr}" />
			</div>
		{/jstab}
{* End Each Type *}
{/literal}{/foreach}{literal}
	{/jstabs}
{/form}
{/strip}{/literal}