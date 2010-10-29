{strip}
{{include file="smarty_file_header.tpl}}
{{* Package Settings *}}
{{if $config.settings}}
		{jstab title="{{$Plugin}} Plugin Settings"}
{{foreach from=$config.settings key=pkgSettingsName item=pkgSettingGroup name=pkgSettings}}
			{include file="bitpackage:kernel/config_options_inc.tpl" legend="{{$pkgSettingsName|ucfirst}} Features" options=$form{{$Package}}{{$Plugin}}{{$pkgSettingsName|ucfirst}}}
{{/foreach}}
			<div class="buttonHolder row submit">
				<input class="button" type="submit" name="{{$plugin}}_settings" value="{tr}Change preferences{/tr}" />
			</div>
		{/jstab}
{{/if}}
{{* End Package Settings *}}
{/strip}
