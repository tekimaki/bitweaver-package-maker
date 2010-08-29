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
							{elseif $output.type=="hexcolor"}
								<input size="6" type="text" name="{$item}" id="{{$item}}" value="{$gBitSystem->getConfig($item,$output.default)}" />
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
