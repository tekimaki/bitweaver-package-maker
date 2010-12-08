{strip}
{{foreach from=$config.typemaps item=typemap key=typemapName name=typemaps}}
{{foreach from=$typemap.fields item=field key=fieldName name=fields}}
{{if $field.input.type == "reference" }}
{if $req == 'fetch_{{$typemapName}}_{{$fieldName}}_list'}
	{if !empty($error)}
		<div class="error" id="{{$fieldName}}">{$error}</div>
	{else}
{{if $typemap.input.style == 'list'}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'reference'}}
{{if $typemap.input.style == 'list'}}

<div id="available_{{$typemapName}}">
{{foreach from=$typemap.fields item=field key=fieldName name=fields}}
{{if $field.input.type == 'reference'}}

{foreach from=${{$typemapName}}_{{$fieldName}}_options item=option key=index name=options}
<div class="row" id="{{$config.name}}_{{$typemapName}}_{$index}">
<span class="title">{$option}</span>
<div class="listbuttons">
<input type-"button" class="button small multiform_add" href="javascript:void(0);" name="add_{{$typemapName}}_temp" value="Add" onclick="BitMultiForm.addList('{{$config.name}}_{{$typemapName}}_temp', '{$index}', '{$option}', '{{$config.name}}_{{$typemapName}}_sortable'{{if $typemap.validate.max}}, {{$typemap.validate.max}}{{/if}});" />
<input type-"button" class="button small multiform_delete" href="javascript:void(0);"  value="Delete" onclick="alert('Delete Not Inplemented')" />
</div>
</div>
{/foreach}

{{/if}}
{{/foreach}}

{{foreach from=$typemap.fields item=field key=fieldName name=fields}}
{{if $field.input.type == 'reference'}}

{* pagination *}
{include file="bitpackage:kernel/jspagination.tpl" ajaxHandler="{{$config.class_name}}.{{$typemapName}}_list" listInfo="${{$typemapName}}_{{$fieldName}}_listInfo" ajaxParams="'available_{{$typemapName}}','{{$config.plugin}}_{{$typemapName}}_multiform'" forceAjaxPagination=true}
{* Empty one to fill *}
{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl" index="temp" rep=0}
{{* <input type="submit" class="button small multiform_prev" value="&lt;- {tr}Previous{/tr}" href="javascript:void(0);" onclick="{{$config.plugin}}.{{$typemapName}}_{{$fieldName}}_page('-1');return false;"/>
<input type="submit" class="button small right multiform_next" value="{tr}Next{/tr} -&gt;"  href="javascript:void(0);" onclick="{{$config.plugin}}.{{$typempName}}_{{$fieldName}}_page('1');return false;"/>
*}}

{{/if}}
{{/foreach}}
</div>

{{else}}
{foreach from=${{$typemapName}}_{{$fieldName}}_options key=index item=option name=options}
<div id="{{$config.name}}_{{$typemapName}}_{$index}" class="row multiform_choice">
	{$option}
	<input id="{{$config.name}}_{{$typemapName}}_{$index}_add" type="button" class="button small multiform_add" href="javascript:void(0);" name="add_{{$typemapName}}_temp" value="Add" onclick="BitMultiForm.addList('{{$config.plugin}}_{{$typemapName}}_temp', '{$index}', '{$option}', '{{$config.plugin}}_{{$typemapName}}{{if empty($typemap.sortable)}}_multiform{{else}}_sortable{{/if}}'{{if $typemap.validate.max}},{{$typemap.validate.max|default:-1}}{{/if}})" />
</div>
{/foreach}
	{* Empty one to fill in *}
	{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl" index="temp" rep=0}
{{/if}}
{{/if}}
{{/foreach}}
{{else}}
	{* This is support for one-to-many content types where 
		multiple copies of the same input might be in the form 
		This shit is seriously complicated to render *}
		<select style="width:100%" name="{{$namespace}}[{{$fieldName}}]" id='{{$fieldName}}_{$index}' size="{{$field.input.size|default:10}}" >
			{html_options options=${{$fieldName}}_options  selected=$selected}
		</select>
{{/if}}
	{/if}
{/if}
{{/if}}
{{/foreach}}
{{/foreach}}
{/strip}