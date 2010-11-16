{if $gContent->isValid() && $gContent->hasUserPermission('p_{{$typemapName}}_service_update') ||
	$gContent->hasUserPermission('p_{{$typemapName}}_service_edit')}
{legend legend="{{$typemap.label}}"}

{{* one-to-many typemaps without attachment fields *}}
{{if $typemap.relation eq 'one-to-many' && !$typemap.attachments}}
{* multiform block *}
<div id="{{$config.plugin}}_{{$typemapName}}_multiform">
	{* if we have existing reps we create an input block for each one *}
	{foreach from=$gContent->mInfo.{{$typemapName}} item={{$typemapName}} key=index}
		{if is_int($index)} {* temp index can be set on submit so we need to exclude it from list *}
			{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl" {{$typemapName}}={{$typemapName}} errors=$errors.{{$typemapName}}.$index index=$index}
		{/if}
	{* if we have none we present a blank input block *}
	{foreachelse}
		{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl"}
	{/foreach}
</div>

{* link to load multiforms*}
<div class="row">
	{forminput}
		<a href="javascript:void(0);" onclick="BitMultiForm.addForm('{{$config.plugin}}_{{$typemapName}}_temp', '{{$config.plugin}}_{{$typemapName}}_multiform')" />{tr}Add another {{$typemapName|ucfirst}}{/tr}</a>
	{/forminput}
</div>

{* to support multiple {{$typemapName}} instances a temp input block which can be cloned by js is included - requires BitBase.MultiForm.js handlers *}
{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl" index="temp" rep=0}

{{* one-to-many typemaps with attachment fields *}}
{{elseif $typemap.relation eq 'one-to-many' && $typemap.attachments}}
{if !$formid && $smarty.request.section}
{assign var=formid value="edit`$smarty.request.section`form"}
{/if}
<div id="{{$config.plugin}}_{{$typemapName}}">
{* place a fieldset for each existing instance *}
{foreach from=$gContent->mInfo.{{$typemapName}} item={{$typemapName}} key=index}
{{include file="fieldset_valid_attch_inc.tpl"}} 
{/foreach}
{* place empty fieldset at the bottom *}
{{include file="fieldset_typemap_inc.tpl.tpl"}} 
</div>

{{* many-to-many *}} 
{{elseif $typemap.relation eq 'many-to-many'}}
{{* @TODO many-to-many *}}

{{* one-to-one typemaps with attachments *}}
{{elseif $typemap.attachments}}
<div id="{{$config.plugin}}_{{$typemapName}}">
{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl"}
</div>
{{* one-to-one typemaps *}}
{{else}}
{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl"}
{{/if}}
{/legend}
{/if}
