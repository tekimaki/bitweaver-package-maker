{{if $typemap.relation eq 'one-to-many' && $typemap.attachments}}
{assign var=index value=0} {* new attachment must always have index of 0 *}
<div id="{{$config.name}}_{{$typemapName}}">
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id'}}
<div class="row" id="row_{{$config.name}}_{{$fieldName}}" {{if $field.input.styles.row}}style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}"{{/if}}>
{{assign var=namespace value="`$config.name`[`$typemapName`]["|cat:'{$index}]'}}
{{include file="edit_field.tpl" namespace=$namespace index=y}}
</div>
{{/if}}
{{/foreach}}
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
{{include file="typemap_attachment_field.tpl"}}
{{/foreach}}
</div>
{{/if}}{{* end one-to-many and attachment requirement *}}
