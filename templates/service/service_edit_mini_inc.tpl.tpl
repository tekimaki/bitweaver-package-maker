{strip}
{{* Plugin edit *}}
{{if !empty($config.plugin) }}

{if $gContent->hasService($smarty.const.LIBERTY_SERVICE_{{$config.name|strtoupper}})} 
{{foreach from=$config.typemaps key=typemapName item=typemap name=typemaps}}
{{if $typemap.services && in_array('content_edit_mini',$typemap.services)}}
{if {{if !$typemap.service_prefs || in_array('content',$typemap.service_prefs)}}!$smarty.request.preflight_fieldset_guid || {{/if}} $smarty.request.preflight_fieldset_guid eq '{{$typemapName}}'}
{include file="bitpackage:{{$config.package}}/{{$config.plugin}}/edit_{{$typemapName}}_inc.tpl"}
{/if}
{{/if}}
{{/foreach}}
{/if}

{{else}}
{{* Content Service edit *}}
{{foreach from=$config.services key=serviceName item=service}}
{if $gContent->hasService($smarty.const.LIBERTY_SERVICE_{{$serviceName|strtoupper}})} 
	{if $gContent->isValid() && $gContent->hasUserPermission('p_{{$serviceName}}_update') ||
		$gContent->hasUserPermission('p_{{$serviceName}}_view')}
	{legend legend=$serviceName.label|default:$serviceName}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id'}}
		<div class="row" id="row_{{$serviceName}}_{{$fieldName}}" style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}">
{{include file="edit_field.tpl" namespace=`$serviceName`}}
		</div>
{{/if}}
{{/foreach}}
        {/legend}
        {/if}
{/if}
{{/foreach}}
{{/if}}
{/strip}
