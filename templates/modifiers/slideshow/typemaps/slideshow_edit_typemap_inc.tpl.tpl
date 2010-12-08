{{* one-to-many typemaps with attachment fields *}}
{if $gContent->isValid() && $gContent->hasUserPermission('p_{{$typemapName}}_service_update') ||
	$gContent->hasUserPermission('p_{{$typemapName}}_service_create')}
{if !$formid && $smarty.request.section}
{assign var=formid value="edit`$smarty.request.section`form"}
{/if}

{legend legend="{{$typemap.label}}"}

<div id="{{$config.plugin}}_{{$typemapName}}" class="slideshow">
<div class="row">                                       {* master fieldset row container *}
{formlabel label="Images" for="store_{{$typemapName}}"} {* master formlabel container *}
{forminput}                              				{* master forminput container *}

{* new {{$typemapName}} fieldset *}
{legend legend="Upload a new {{$typemap.label}}"}
{{include file="slideshow_fieldset_typemap_inc.tpl.tpl"}} 
{/legend}

{* place a fieldset for each existing instance *}
{legend legend="Existing {{$typemap.label}}"}
{foreach from=$gContent->mInfo.{{$typemapName}} item={{$typemapName}} key=index}
{{include file="slideshow_fieldset_valid_attch_inc.tpl"}} 
{/foreach}
{/legend}

{/forminput}                    {* end master forminput container *}
</div>                          {* end master fieldset row container *}
</div>
{/legend}
{/if}
