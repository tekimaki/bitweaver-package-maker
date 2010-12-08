{if $gContent->isValid() && $gContent->hasUserPermission('p_{{$config.name}}_{{$typemapName}}_service_update') ||
	$gContent->hasUserPermission('p_{{$config.name}}_{{$typemapName}}_service_create')}
{legend legend="{{$typemap.label}}"}
{{* one-to-many typemaps without attachment fields *}}
{{if $typemap.relation eq 'one-to-many' && !$typemap.attachments}}
{* multiform block *}
<div id="{{$config.plugin}}_{{$typemapName}}_multiform">
{{if !empty($typemap.sortable)}}<ul style="width:100%;margin-left:10px" class="sortable" id="{{$config.plugin}}_{{$typemapName}}_sortable">{{/if}}
	{* if we have existing rows we create an input block for each one *}
	{foreach from=$gContent->mInfo.{{$typemapName}} item={{$typemapName}} key=index}
		{if is_int($index)} {* temp index can be set on submit so we need to exclude it from list *}
			{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl" {{$typemapName}}={{$typemapName}} errors=$errors.{{$typemapName}}.$index index=$index}
		{/if}
	{* if we have none we present a blank input block *}
	{foreachelse}
		{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/fieldset_{{$typemapName}}_inc.tpl"}
	{/foreach}
{{if !empty($typemap.sortable)}}</ul>
<script>
	jQuery( "#{{$config.name}}_{{$typemapName}}_sortable" ).sortable({ldelim}
		placeholder: "ui-state-highlight",
                update : function () {ldelim}
                   var order = jQuery('#{{$config.name}}_{{$typemapName}}_sortable').sortable('toArray'); 
                   var re = /.*_([0-9]+)$/;
                   for(var i = 0; i < order.length; i++) {ldelim} 
                      var id = re.exec([order[i]])[1];
                      jQuery('#{{$typemap.sortable}}_'+id).val(i);
                   {rdelim}
                {rdelim}
	{rdelim});
	jQuery( "#{{$config.name}}_{{$typemapName}}_sortable" ).disableSelection();
</script>
{{/if}}
</div>

{* Display a message about sorting *}
<div class="row">
{forminput}
	{formhelp note="You can sort the {{$typemap.label}} by dragging and dropping"}
{/forminput}
</div>
{* link to load multiforms*}
<div class="buttonHolder row" id="{{$config.plugin}}_{{$typemapName}}_add_button">
	{forminput}
		<a class="button add" href="javascript:void(0);" onclick="BitMultiForm.addForm('{{$config.plugin}}_{{$typemapName}}_temp', '{{$config.plugin}}_{{$typemapName}}{{if empty($typemap.sortable)}}_multiform{{else}}_sortable{{/if}}'{{if $typemap.validate.max}},{{$typemap.validate.max|default:-1}}{{/if}})" />{tr}Add another {{$typemap.label}}{/tr}</a>
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
{{elseif $typemap.relation eq 'many-to-many' && !$typemap.graph}}
{{* many-to-many graph *}}
{{elseif $typemap.relation eq 'many-to-many' && $typemap.graph }}
{{include file="edit_typemap_graph_inc.tpl" typemap=$typemap}}

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
