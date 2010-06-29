{strip}
{{include file="bitpackage:pkgmkr/smarty_file_header.tpl}}
{form}
	{jstabs}
{* Are there homeable settings? *}
{{if $config.homeable}}
		{jstab title="{{$Package}} Home Settings"}
			{legend legend="{{$Package}} Home Settings"}
				<input type="hidden" name="page" value="{$page}" />
				<div class="row">
					{formlabel label="{{$Package}} Home Type"}
					{forminput}
						<select name="{{$package}}_home_type" id="home{{$Package}}">
							{section name=ix loop=$homeTypes}
								<option value="{$homeTypes[ix]|escape}" {if ${{$package}}_home_type == $homeTypes[ix]}selected="selected"{/if} >{$homeTypes[ix]}</option>
							{/section}
						</select>
					{/forminput}
				</div>		
{* Output for each type *}
{{foreach from=$config.types key=typeName item=type name=types}}
				<div class="row">
					{formlabel label="Home {{$typeName|capitalize}}" for="home{{$typeName|capitalize}}"}
					{forminput}
						<select name="{{$package}}_{{$typeName}}_home_id" id="home{{$typeName|capitalize}}">
							{section name=ix loop=${{$typeName}}_data}
								<option value="{${{$typeName}}_data[ix].{{$typeName}}_id|escape}" {if ${{$typeName}}_data[ix].{{$typeName}}_id eq ${{$package}}_{{$typeName}}_home_id}selected="selected"{/if}>{${{$typeName}}_data[ix].title|escape|truncate:20:"...":true}</option>
							{sectionelse}
								<option>{tr}No records found{/tr}</option>
							{/section}
						</select>
						{formhelp note="This is the {{$typeName}} that will be displayed when viewing the {{$package}} homepage if {{$Package}} Home Type above is set to {{$typeName}}"}
					{/forminput}
				</div>
{* End foreach type *}
{{/foreach}}
			{/legend}
			<div class="row submit">
				<input type="submit" name="{{$package}}_settings" value="{tr}Change preferences{/tr}" />
			</div>
		{/jstab}
{* End homeable section *}
{{/if}}

{{* Package Settings *}}
{{if $config.settings}}
		{jstab title="{{$Package}} Settings"}
{{foreach from=$config.settings key=pkgSettingsName item=pkgSettingGroup name=pkgSettings}}
            {legend legend="{{$pkgSettingsName|ucfirst}} Features"}
                {foreach from=$form{{$pkgSettingsName|ucfirst}} key=item item=output}
                    <div class="row">
						{formlabel label=`$output.label` for=$item}
                        {forminput}
                            {if $output.type == 'numeric'}
                                <input size="5" type='text' name="{$item}" id="{$item}" value="{$gBitSystem->getConfig($item,$output.default)}" />
                            {elseif $output.type == 'input'}
                                <input type='text' name="{$item}" id="{$item}" value="{$gBitSystem->getConfig($item,$output.default)}" />
                            {else}
                                {html_checkboxes name="$item" values="y" checked=$gBitSystem->getConfig($item,$output.default) labels=false id=$item}
                            {/if}
                            {formhelp note=`$output.note` page=`$output.page`}
                        {/forminput}
                    </div>
                {/foreach}
            {/legend}
{{/foreach}}
			<div class="row submit">
				<input type="submit" name="{{$package}}_settings" value="{tr}Change preferences{/tr}" />
			</div>
		{/jstab}
{{/if}}
{{* End Package Settings *}}

{{* For Each Type Settings *}}
{{foreach from=$config.types key=typeName item=type name=types}}
	{jstab title="{{$type.content_name|capitalize}} Settings"}
	{jstabs}

{{* Defined Type Settings *}}
{{if $type.settings}}
{{foreach from=$type.settings key=typeSettingsName item=typeSettingGroup name=typeSettings}}
			{jstab title="{{$typeSettingsName|ucfirst}} Settings"}
				{legend legend="{{$typeSettingsName|ucfirst}} Features"}
				{foreach from=$form{{$typeName|ucfirst}}{{$typeSettingsName|ucfirst}} key=item item=output}
						<div class="row">
							{formlabel label=`$output.label` for=$item}
							{forminput}
								{if $output.type == 'numeric'}
									<input size="5" type='text' name="{$item}" id="{$item}" value="{$gBitSystem->getConfig($item,$output.default)}" />
								{elseif $output.type == 'input'}
									<input type='text' name="{$item}" id="{$item}" value="{$gBitSystem->getConfig($item,$output.default)}" />
								{else}
									{html_checkboxes name="$item" values="y" checked=$gBitSystem->getConfig($item,$output.default) labels=false id=$item}
								{/if}
								{formhelp note=`$output.note` page=`$output.page`}
							{/forminput}
						</div>
					{/foreach}
				{/legend}
			{/jstab}
{{/foreach}}
{{/if}}
{{* End Defined Type Settings *}}

{{* List Settings *}}

			{jstab title="{{$type.content_name|capitalize}} List Settings"}
				{legend legend="{{$type.content_name|capitalize}} List Settings"}
					<input type="hidden" name="page" value="{$page}" />
					{foreach from=$form{{$typeName}}Lists key=item item=output}
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
					<input type="submit" name="{{$package}}_settings" value="{tr}Change preferences{/tr}" />
				</div>
			{/jstab}
{* End List Settings *}

		{/jstabs}
	{/jstab}
{{/foreach}}
{{* End Each Type *}}

	{/jstabs}
{/form}
{/strip}
