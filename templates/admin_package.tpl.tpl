{literal}{strip}
{form}
	{jstabs}
		{jstab title="{/literal}{$Package}{literal} Settings"}
			{legend legend="{/literal}{$Package}{literal} Settings"}
				<input type="hidden" name="page" value="{$page}" />
				<div class="row">
					{formlabel label="Home {/literal}{$Package}{literal}" for="home{/literal}{$Package}{literal}"}
					{forminput}
						<select name="{/literal}{$package}{literal}_home_id" id="home{/literal}{$Package}{literal}">
							{section name=ix loop=${/literal}{$package}{literal}_data}
								<option value="{${/literal}{$package}{literal}_data[ix].{/literal}{$package}{literal}_id|escape}" {if ${/literal}{$package}{literal}_data[ix].{/literal}{$package}{literal}_id eq ${/literal}{$package}{literal}_home_id}selected="selected"{/if}>{${/literal}{$package}{literal}_data[ix].title|escape|truncate:20:"...":true}</option>
							{sectionelse}
								<option>{tr}No records found{/tr}</option>
							{/section}
						</select>
						{formhelp note="This is the {/literal}{$package}{literal} that will be displayed when viewing the {/literal}{$package}{literal} homepage"}
					{/forminput}
				</div>
			{/legend}
		{/jstab}

		{jstab title="List Settings"}
			{legend legend="List Settings"}
				<input type="hidden" name="page" value="{$page}" />
				{foreach from=$form{/literal}{$Package}{literal}Lists key=item item=output}
					<div class="row">
						{formlabel label=`$output.label` for=$item}
						{forminput}
							{html_checkboxes name="$item" values="y" checked=$gBitSystem->getConfig($item) labels=false id=$item}
							{formhelp note=`$output.note` page=`$output.page`}
						{/forminput}
					</div>
				{/foreach}
			{/legend}
		{/jstab}

		<div class="row submit">
			<input type="submit" name="{/literal}{$package}{literal}_settings" value="{tr}Change preferences{/tr}" />
		</div>
	{/jstabs}
{/form}
{/strip}{/literal}