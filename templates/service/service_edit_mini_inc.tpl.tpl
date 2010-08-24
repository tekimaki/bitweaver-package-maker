{strip}
{if $gContent->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} )} 
{{foreach from=$config.typemaps key=typemapName item=typemap name=typemaps}}
	{if $gContent->isValid() && $gBitUser->hasPermission('p_{{$typemapName}}_service_update') ||
		$gBitUser->hasPermission('p_{{$typemapName}}_service_view')}
		{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
		<div class="row" id="row_{{$config.name}}_{{$fieldName}}" style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}">
			{formfeedback warning=$errors.{{$fieldName}}}
			{formlabel label="{{$typemap.label}}" for="{{$fieldName}}"}
			{forminput}
			{{include file="edit_field.tpl" type=$config}}
			{{if $field.validator.required}}{required}{{/if}}
			{formhelp note="{{$field.help}}"}
			{/forminput}
		</div>
		{{/foreach}}
	{/if}
{{/foreach}}
{/if}
{/strip}
