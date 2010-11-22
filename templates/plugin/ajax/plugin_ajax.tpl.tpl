{strip}
{{foreach from=$config.typemaps item=typemap key=typemapName name=typemaps}}
{{foreach from=$typemap.fields item=field key=fieldName name=fields}}
{{if $field.input.type == "reference" }}
{if $req == 'fetch_{{$typemapName}}_{{$fieldName}}_list'}
	{if !empty($error)}
		<div class="error" id="{{$fieldName}}">{$error}</div>
	{else}
	{* This is support for one-to-many content types where 
		multiple copies of the same input might be in the form 
		This shit is seriously complicated to render *}
		<select style="width:100%" name="{{$namespace}}[{{$fieldName}}]" id='{{$fieldName}}_{$index}' size="{{$field.input.size|default:10}}" >
			{html_options options=${{$fieldName}}_options  selected=$selected}
		</select>
	{/if}
{/if}
{{/if}}
{{/foreach}}
{{/foreach}}
{/strip}