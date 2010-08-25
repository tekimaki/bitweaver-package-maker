{{if !empty($field.input.type)}}
	{{if !$namespace}}{{assign var=namespace value=$type.name}}{{/if}}
    {{if $field.input.type=="choice"}}
	    <select name="{{$namespace}}[{{$fieldName}}]" id="{{$fieldName}}" {{if $field.validator.muliple}}multiple="multiple" {{/if}}>
		{{foreach from=$field.validator.choices item=choice}}
		<option>{{$choice}}</option>
		{{/foreach}}
	    </select>
    {{elseif $field.input.type=="hexcolor"}}
    	    <input type="text" class="color {ldelim}required:{{if $field.validator.required}}true{{else}}false{{/if}}{rdelim}" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="date"}}
    	    {html_select_date field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }
    {{elseif $field.input.type=="time"}}
    	    {html_select_time field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }
    {{elseif $field.input.type=="timestamp"}}
    	    {html_select_date field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }{html_select_time field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time=$gContent->getField("{{$fieldName}}") {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}"{{/foreach}} }
    {{elseif $field.input.type=="boolean"}}
    	    <input type="checkbox" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" {if $gContent->getField("{{$fieldName}}")}checked="checked"{/if}/>
    {{elseif $field.input.type=="int" || $field.input.type=="long"}}
    	    <input type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="float" || $field.input.type=="double"}}
    	    <input type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="email"}}
    	    <input type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="url"}}
    	    <input type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="regex"}}
    	    <input type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{elseif $field.input.type=="string"}}
    	    <input type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
	{{elseif $field.input.type=="textarea"}}
			<textarea id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" rows="{{$field.input.rows|default:"20"}}">{$gContent->getField("{{$fieldName}}")}</textarea>
    {{elseif $field.input.type=="select"}}
	{html_options id="{{$fieldName}}" options=${{$field.input.optionsHashName}} name="{{$namespace}}[{{$fieldName}}]" selected=$gContent->getField('{{$fieldName}}') {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}} }
    {{else}}
    	    <input type="text" id="{{$fieldName}}" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField("{{$fieldName}}")}" />
    {{/if}}
{{else}}
	<input type="text" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField('{{$fieldName}}')}" id="{{$fieldName}}" />
{{/if}}
