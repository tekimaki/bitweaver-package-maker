{{* This tpl is only for one-to-many typemaps with attachment(s) *}}
<div id="{{$config.name}}_{{$typemapName}}_{$index}" class="slideshow_slide">
{{* the row displayed when edit form is hidden *}}
<div id="{{$config.name}}_{{$typemapName}}_{$index}_selectbar" class="slideshow_slide_selectbar" {if $newrow}style="display:none"{/if}>
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
{if $gContent->hasUserPermission('p_liberty_attach_attachments') }
	{assign var=attachment_id value=${{$typemapName}}.{{$attachment}}_id}
	<a class="button small" href="javascript:void(0);" onclick="BitSlideshow.showFieldset('{{$config.name}}_{{$typemapName}}_{$index}');">{tr}Edit{/tr}</a>
	{if $gContent->mStorage.$attachment_id}
		{assign var=storage value=$gContent->mStorage.$attachment_id}
		<img class="thumb" src="{$storage.thumbnail_url.icon}" alt="{$storage.filename}" title="{$storage.filename}"/>&nbsp;
	{/if}
	{{foreach from=$typemap.modifier.slideshow.caption item=caption}}
		{{literal}}{${{/literal}}{{$caption}}{{literal}}|truncate:40}{{/literal}}
	{{/foreach}}
{/if}
{{/foreach}}
</div>
{{* the edit form *}}
<div id="{{$config.name}}_{{$typemapName}}_{$index}_fieldset" class="slideshow_slide_fieldset" {if !$newrow}style="display:none"{/if}>
	<a class="hide" href="javascript:void(0);" onclick="BitSlideshow.hideFieldset('{{$config.name}}_{{$typemapName}}_{$index}');">{tr}Hide{/tr}</a>
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
{{include file="typemap_valid_attachment_field.tpl"}} 
{if $gContent->hasUserPermission('p_liberty_attach_attachments') }
	{assign var=attachment_id value=${{$typemapName}}.{{$attachment}}_id}
	{if $gContent->mStorage.$attachment_id}
		{assign var=storage value=$gContent->mStorage.$attachment_id}
		<div class="html_attachment_code">
			<h5>{tr}HTML Code:{/tr}</h5>
			{if $storage.attachment_plugin_guid eq 'mimeimage' || $storage.attachment_plugin_guid eq 'mimedefault'}
				{foreach name=size key=size from=$storage.thumbnail_url item=url}
				{if $size == 'medium'}
					<input name="attachment_source_{$size}_{$storage.attachment_id}" value='&lt;img src="{$url|escape}" /&gt;' readonly="readonly" class="textInput html-include" />
				{/if}
				{/foreach}
			{/if}
		</div>
	{/if}
{/if}
{{/foreach}}
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
<div class="row buttonHolder">
	<a href="javascript:void(0);"
		onclick="LibertyPreflight.expunge(
			document.getElementById('{$formid}'), 
			'{$smarty.const.LIBERTY_PKG_URL}preflight_uploader.php',
			'{tr}Please wait for the delete process to finish.{/tr}',
			'liberty_upload_frame_{{$config.name}}_{{$typemapName}}',
			'{{$config.name}}',
			'{{$typemapName}}',
			'{{$config.name}}_{{$typemapName}}_{$index}'
		);"
		/>{tr}Delete Image{/tr}&raquo;</a>
</div>
</div>
</div>{* edit {{$config.name}}_{{$typemapName}}_{$index} *}
