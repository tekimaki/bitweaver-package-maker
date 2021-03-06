{strip}
{{if $typemap.relation eq 'one-to-many'}}
{{if $typemap.attachments}}
{assign var=index value=0} {* new attachment must always have index of 0 *}
{{else}}
{if !$index}
    {assign var=index value=0}
{/if}
{{/if}}
{{if !$typemap.attachments}}
{{if empty($typemap.sortable)}}<div{{else}}<li{{/if}} id="{{$config.name}}_{{$typemapName}}_{$index}" class="multiform_unit" style="{if !is_int($index) && $index == 'temp'}display:none{/if}">
{{else}}
{{if empty($typemap.sortable)}}<div{{else}}<li{{/if}} id="{{$config.name}}_{{$typemapName}}_{$index}">
{{/if}}
{{/if}}

{{if $config.sections.$typemapName.fieldsets}}
{{*TEMP: If fieldsets exist in section*}}

{{foreach from=$config.sections.$typemapName.fieldsets key=typeMap item=typeMapField name=typeMapfields}}
{{assign var=fieldsets_section value=$typeMapField.section}}
{{assign var=fieldsets_field value=$typeMapField.field}}

{{if $config.typemaps.$fieldsets_section.fields.$fieldsets_field}}
{{*Fields*}}
{{assign var=fieldName value=$fieldsets_field}}
{{assign var=field value=$config.typemaps.$fieldsets_section.fields.$fieldsets_field}}
{{assign var=fieldsets_typemap value=$config.typemaps.$fieldsets_section}}

<div class="row" id="row_{{$config.name}}_{{$fieldName}}" {{if $field.input.styles.row}}style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}"{{/if}}>
{{if $fieldsets_typemap.relation eq 'one-to-many'}}
{{assign var=namespace value="`$config.name`[`$fieldsets_section`]["|cat:'{$index}]'}}
{{include file="edit_field.tpl" namespace=$namespace index=y}}
{{else}}
{{include file="edit_field.tpl" namespace=`$config.name`[`$fieldsets_section`]}}
{{/if}}
</div>
{{elseif $config.typemaps.$fieldsets_section.attachments.$fieldsets_field}}
{{*Attachments*}}
{{assign var=attachment value=$fieldsets_field}}
{{assign var=prefs value=$config.typemaps.$fieldsets_section.attachments.$fieldsets_field}}
{{include file="typemap_attachment_field.tpl"}}
{{/if}}
{{/foreach}}
{{if $typemap.relation eq 'one-to-many'}}
</div>
{{/if}}

{{else}}
{{*TEMP: If fieldsets not exist in section*}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id' && $field.input.type != "none"}}
{{if $field.input.type != "hidden" }}
<div class="row" id="row_{{$config.name}}_{{$fieldName}}" {{if $field.input.styles.row}}style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}"{{/if}}>
{{/if}}
{{if $typemap.relation eq 'one-to-many'}}
{{assign var=namespace value="`$config.name`[`$typemapName`]["|cat:'{$index}]'}}
{{include file="edit_field.tpl" namespace=$namespace index=y}}
{{else}}
{{include file="edit_field.tpl" namespace=`$config.name`[`$typemapName`]}}
{{/if}}
{{if $field.input.type != "hidden" }}
</div>
{{/if}}
{{/if}}
{{/foreach}}
{{if $typemap.relation eq 'one-to-many' && !$typemap.attachments}}
{{if $typemap.input.style != 'list'}}
{if $index != '0'}
{{/if}}
{{if $typemap.input.style == "list"}}
<div class="listbuttons">
{{else}}
<div class="row">
{{/if}}
	<input type="button" class="button small multiform_remove" href="javascript:void(0);" name="expunge_{{$typemapName}}_{$index}" value="Remove" onclick="BitMultiForm.removeForm('{{$config.name}}_{{$typemapName}}_{$index}');"/>
</div>
{{if $typemap.input.style != 'list'}}
{/if}
{{/if}}
{{/if}}
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
{{include file="typemap_attachment_field.tpl"}}
{{/foreach}}
{{if $typemap.relation eq 'one-to-many'}}
{{if empty($typemap.sortable)}}</div>{{else}}</li>{{/if}}
{{/if}}
{{/if}}{{* end one-to-many special requirements *}}
{/strip}
