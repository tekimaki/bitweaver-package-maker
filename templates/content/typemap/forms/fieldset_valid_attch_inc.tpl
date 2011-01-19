{{* This tpl is only for one-to-many typemaps with attachment(s) *}}
<div id="{{$config.name}}_{{$typemapName}}_{$index}">
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id'}}
<div class="row" id="row_{{$config.name}}_{{$fieldName}}" {{if $field.input.styles.row}}style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}"{{/if}}>
{{assign var=namespace value="`$config.name`[`$typemapName`]["|cat:'{$index}]'}}
{{include file="edit_field.tpl" namespace=$namespace index=y}}
</div>
{{/if}}
{{/foreach}}
{{if $typemap.sequence}}
<div class="row" style="display:none">
	<input type="hidden" name="{{$namespace}}[{{$typemapName}}_id]" value="{${{$typemapName}}.{{$typemapName}}_id}" />
</div>
{{/if}}
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
{{include file="typemap_valid_attachment_field.tpl"}} 
{{/foreach}}
<div class="row remove">
	<input type="buttom" class="button small" href="javascript:void(0);" name="expunge_{{$typemapName}}_{$index}" value="Delete" 
		onclick="LibertyPreflight.expunge(
			this.form, 
			'{$smarty.const.LIBERTY_PKG_URL}preflight_uploader.php',
			'{tr}Please wait for the delete process to finish.{/tr}',
			'liberty_upload_frame_{{$config.name}}_{{$typemapName}}',
			'{{$config.name}}',
			'{{$typemapName}}',
			'{{$config.name}}_{{$typemapName}}_{$index}'
		);"
	/>
</div>
</div>
