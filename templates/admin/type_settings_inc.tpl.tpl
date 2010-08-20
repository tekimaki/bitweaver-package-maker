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

