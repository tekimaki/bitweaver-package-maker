{{if $typemap.relation eq 'one-to-many'}}
{{if $typemap.attachments}}
{assign var=index value=0} {* new attachment must always have index of 0 *}
{{else}}
{if !$index}
    {assign var=index value=0}
{/if}
{{/if}}
{{if !$typemap.attachments}}
<div id="{{$config.name}}_{{$typemapName}}_{$index}" class="multiform_unit" style="{if !is_int($index) && $index == 'temp'}display:none{/if}">
{{else}}
<div id="{{$config.name}}_{{$typemapName}}_{$index}">
{{/if}}
{{/if}}{{* end one-to-many special requirements *}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id'}}
<div class="row" id="row_{{$config.name}}_{{$fieldName}}" {{if $field.input.styles.row}}style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}"{{/if}}>
{{if $typemap.relation eq 'one-to-many'}}
{{assign var=namespace value="`$config.name`[`$typemapName`]["|cat:'{$index}]'}}
{{include file="edit_field.tpl" namespace=$namespace index=y}}
{{else}}
{{include file="edit_field.tpl" namespace=`$config.name`[`$typemapName`]}}
{{/if}}
</div>
{{/if}}
{{/foreach}}
{{if $typemap.relation eq 'one-to-many' && !$typemap.attachments}}
{if $index != '0'}
<div class="row">
	<input type="buttom" class="button small multiform_remove" href="javascript:void(0);" name="expunge_{{$typemapName}}_{$index}" value="Remove link" onclick="BitMultiForm.removeForm('priorities_priority_related_links_{$index}');"/>
</div>
{/if}
{{/if}}
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
{{include file="typemap_attachment_field.tpl"}}
{{/foreach}}
{{if $typemap.relation eq 'one-to-many'}}
</div>
{{/if}}{{* end one-to-many special requirements *}}
