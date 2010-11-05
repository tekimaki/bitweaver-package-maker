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
	    <select name="{{$namespace}}[{{$fieldName}}]" id="{{$fieldName}}" {{if $field.validator.multiple}}multiple="multiple" size=3{{/if}}>
		{{foreach from=$field.validator.choices item=choice}}
		<option>{{$choice}}</option>
		{{/foreach}}
	    </select>
    {{elseif $field.input.type=="radio"}}
		<ul>
		{{foreach from=$field.validator.choices item=choice}}
		<li><label for="{{$namespace}}[{{$fieldName}}]"><input type="radio" name="{{$namespace}}[{{$fieldName}}]" id="{{$fieldName}}" value="{{$choice}}" {if $gContent->getField("{{$fieldName}}")}checked="checked"{/if}/>&nbsp;{{$choice}}</label></li>
		{{/foreach}}
		</ul>
    {{elseif $field.input.type=="checkbox"}}
		<ul>
		{{foreach from=$field.validator.choices item=choice}}
		<li><label for="{{$namespace}}[{{$fieldName}}]"><input type="checkbox" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{{$choice}}" {if $gContent->getField("{{$fieldName}}")}checked="checked"{/if}/>&nbsp;{{$choice}}</label></li>
		{{/foreach}}
		</ul>
    {{elseif $field.input.type=="hexcolor"}}
    	    <input class="textInput" type="text" class="color {ldelim}required:{{if $field.validator.required}}true{{else}}false{{/if}}{rdelim}" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="hexcolor"}}
    	    <input class="textInput" type="text" class="color {ldelim}required:{{if $field.validator.required}}true{{else}}false{{/if}}{rdelim}" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="date"}}
    	    {html_select_date field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }
    {{elseif $field.input.type=="time"}}
    	    {html_select_time field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }
    {{elseif $field.input.type=="timestamp"}}
    	    {html_select_date field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }{html_select_time field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}"{{/foreach}} }
    {{elseif $field.input.type=="boolean"}}
    	    <input type="checkbox" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" {if $gContent->getField("{{$fieldName}}")}checked="checked"{/if}/>
    {{elseif $field.input.type=="int" || $field.input.type=="long"}}
    	    <input class="textInput" type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="float" || $field.input.type=="double"}}
    	    <input class="textInput" type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="email"}}
    	    <input class="textInput" type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="url"}}
    	    <input class="textInput" type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="regex"}}
    	    <input class="textInput" type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="string"}}
    	    <input class="textInput" type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="textarea"}}
	    	<textarea id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" rows="{{$field.input.rows|default:"20"}}">{$gContent->getField("{{$fieldName}}")}</textarea>
    {{elseif $field.input.type=="parsed"}}
            {textarea label="{{$field.name}}" error=$errors.{{$fieldName}} help="{{$field.help}}" noformat="true" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" rows="{{$field.input.rows|default:"20"}}"}{$gContent->getField("{{$fieldName}}")}{/textarea}
    {{elseif $field.input.type=="select"}}
    {{if empty($field.input.multiple) }}{html_options id="{{$fieldName}}" options=${{$field.input.optionsHashName}} name="{{$namespace}}[{{$fieldName}}]" selected=$gContent->getField('{{$fieldName}}') {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}} }
    {{else}}<select name="{{$namespace}}[][{{$fieldName}}]" id="{{$fieldName}}" {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}} multiple="multiple" >
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
    	    <input class="textInput" type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{/if}}
{{else}}
	{* No input type *}
	<input class="textInput" type="text" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField('{{$fieldName}}')}" id="{{$fieldName}}" />
{{/if}}

{{if $field.input.type != 'parsed' && $field.input.type != 'none'}}
	{formhelp note="{{$field.help}}"}
	{/forminput}
{{/if}}
