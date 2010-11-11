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
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
{{include file="typemap_valid_attachment_field.tpl"}}
{{/foreach}}
</div>
