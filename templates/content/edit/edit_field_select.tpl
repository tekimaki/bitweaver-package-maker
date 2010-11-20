{{if empty($field.input.multiple) }}
	{html_options id="{{$fieldId}}" options=${{$field.input.optionsHashName}} name="{{$namespace}}[{{$fieldName}}]" selected=$gContent->getField('{{$fieldName}}') {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}} }
{{else}}
	<select name="{{$namespace}}[][{{$fieldName}}]" id="{{$fieldId}}" {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}} multiple="multiple" >
         {foreach from=${{$field.input.optionsHashName}} key=itemKey item=itemValue}
             {assign var=selected value=false}
             {foreach from=$gContent->mInfo.{{$namespace}} item=fieldValues key=keyName name=fields}
		{if $itemKey == $fieldValues.{{$fieldName}}}{assign var=selected  value=true}{/if}
             {/foreach}
             <option value="{$itemKey}" {if $selected}selected='selected'{/if}>
               {$itemValue|escape:html}
             </option>
         {/foreach}
         </select>
{{/if}}
