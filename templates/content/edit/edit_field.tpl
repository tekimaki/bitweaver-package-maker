{{* This is support for one-to-many content types where 
	multiple copies of the same input might be in the form 
	This shit is seriously complicated to render *}}
{{if $index}}
{{assign var=fieldId value=$fieldName|cat:'_{$index}'}}
{{assign var=inputValue value='{$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`}"}}
{{assign var=inputValueAlt value='$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`"}}
{{else}}
{{assign var=fieldId value=$fieldName}}
{{/if}}

{{if $field.input.type != 'parsed' && $field.input.type != 'none'}}
	{formfeedback warning=$errors.{{$fieldName}}}
	{formlabel label="{{$field.name}}" for="{{$fieldName}}" {{if $field.validator.required}}required="y"{{/if}}}
	{forminput}
{{/if}}

{{if !empty($field.input.type)}}
    {{if !$namespace}}{{assign var=namespace value=$type.name}}{{/if}}
    {{if $field.input.type=="none"}}
	{* No input for {{$field.name}} *}
    {{elseif $field.input.type=="choice"}}
		<select name="{{$namespace}}[{{$fieldName}}]" id="{{$fieldId}}" {{if $field.validator.multiple}}multiple="multiple" size=3{{/if}}>
		{{foreach from=$field.validator.choices item=choice}}
		<option>{{$choice}}</option>
		{{/foreach}}
	    </select>
    {{elseif $field.input.type=="radio"}}
		<ul>
		{{foreach from=$field.validator.choices item=choice}}
		<li><label for="{{$namespace}}[{{$fieldName}}]"><input type="radio" name="{{$namespace}}[{{$fieldName}}]" id="{{$fieldId}}" value="{{$choice}}" {if {{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}}}checked="checked"{/if}/>&nbsp;{{$choice}}</label></li>
		{{/foreach}}
		</ul>
    {{elseif $field.input.type=="checkbox"}}
		<ul>
		{{foreach from=$field.validator.choices item=choice}}
		<li><label for="{{$namespace}}[{{$fieldName}}]"><input type="checkbox" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{$choice}}" {if {{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}}}checked="checked"{/if}/>&nbsp;{{$choice}}</label></li>
		{{/foreach}}
		</ul>
    {{elseif $field.input.type=="hexcolor"}}
    	    <input class="textInput" type="text" class="color {ldelim}required:{{if $field.validator.required}}true{{else}}false{{/if}}{rdelim}" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="hexcolor"}}
    	    <input class="textInput" type="text" class="color {ldelim}required:{{if $field.validator.required}}true{{else}}false{{/if}}{rdelim}" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="date"}}
    	    {html_select_date field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time={{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}} {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }
    {{elseif $field.input.type=="time"}}
    	    {html_select_time field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time={{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}} {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }
    {{elseif $field.input.type=="timestamp"}}
    	    {html_select_date field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time={{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}} {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }{html_select_time field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time={{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}} {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}"{{/foreach}} }
    {{elseif $field.input.type=="boolean"}}
    	    <input type="checkbox" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" {if {{if $inputValueAlt}}{{$inputValueAlt}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}}checked="checked"{/if}/>
    {{elseif $field.input.type=="int" || $field.input.type=="long"}}
    	    <input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="float" || $field.input.type=="double"}}
    	    <input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="email"}}
    	    <input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="url"}}
    	    <input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="regex"}}
    	    <input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="string"}}
    	    <input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{elseif $field.input.type=="textarea"}}
	    	<textarea id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" rows="{{$field.input.rows|default:"20"}}">{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}</textarea>
    {{elseif $field.input.type=="parsed"}}
            {textarea label="{{$field.name}}" error=$errors.{{$fieldName}} help="{{$field.help}}" noformat="true" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" rows="{{$field.input.rows|default:"20"}}"}{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}{/textarea}
    {{elseif $field.input.type=="select"}}
    {{if empty($field.input.multiple) }}{html_options id="{{$fieldId}}" options=${{$field.input.optionsHashName}} name="{{$namespace}}[{{$fieldName}}]" selected=$gContent->getField('{{$fieldName}}') {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}} }
    {{else}}<select name="{{$namespace}}[][{{$fieldName}}]" id="{{$fieldId}}" {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}} multiple="multiple" >
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
    {{else}}
    	    {* Default *}
    	    <input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
    {{/if}}
{{else}}
	{* No input type *}
	<input class="textInput" type="text" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField('{{$fieldName}}')}" id="{{$fieldId}}" />
{{/if}}

{{if $field.input.type != 'parsed' && $field.input.type != 'none'}}
	{formhelp note="{{$field.help}}"}
	{/forminput}
{{/if}}
