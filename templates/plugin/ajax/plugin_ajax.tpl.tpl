{strip}
{{foreach from=$config.typemaps item=typemap key=typemapName name=typemaps}}
{{foreach from=$typemap.fields item=field key=fieldName name=fields}}
{{if $field.input.type == "reference" }}
{if $req == 'fetch_{{$typemapName}}_{{$fieldName}}_list'}
	{if !empty($error)}
		<div class="error" id="{{$fieldName}}">{$error}</div>
	{else}
		{{include file="edit_field_reference.tpl"}}
	{/if}
{/if}
{{/if}}
{{/foreach}}
{{/foreach}}
{/strip}