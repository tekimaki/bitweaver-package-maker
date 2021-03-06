{{if $typemap.input.style == 'list'}}
	<span class="title"><input type="hidden" name="{{$namespace}}[{{$fieldName}}]" value="{if $inputValue}{$inputValue}{else}{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}{/if}" class="multiform_input" />
		{if $inputValueDesc}{$inputValueDesc}{else}{{$inputValueDesc}}{/if}
	</span>
{{else}}
{if empty($req)}
<div class="row">
{/if}
<select style="width:100%" name="{{$namespace}}[{{$fieldName}}]" id='{{$fieldId}}' size="{{$field.input.size|default:10}}" >
	{html_options options=${{$typemapName}}_{{$fieldName}}_options  selected={{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}} }
</select>
{*  If this isn't an ajax request *}
{if empty($req)}
</div>
<div class="row">
<input type="text" id="{{$fieldId}}_search" name="{{$fieldName}}_search" value="{${{$fieldName}}_search}" onchange="javascript:jQuery('#{{$fieldId}}_search_button').trigger('click');return false;"> 
<input type="submit" id="{{$fieldId}}_search_button" value="{tr}Search{/tr}" name="{{$fieldName}}_search_button" class="button" onclick="return false;">
<script type="text/javascript">
	jQuery( '#{{$fieldId}}_search_button' ).click(function() {ldelim}
		{{$config.class_name}}.fetch_{{$fieldName}}_list('{{$fieldId}}', '{$index|default:-1}', '{tr}There was a problem fetching the list of{/tr} {{$fieldName}}. {tr}Please try again or contact the administrator.{/tr}');
		return false; 
	{rdelim});
</script>
</div>
{/if}
{{/if}}