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
    {{else}}
	{{assign var=fieldTemplate value="edit_field"|cat:$field.input.type|cat:".tpl"}}
	{{include file=$fieldTemplate}}
    {{/if}}
{{else}}
	{* No input type *}
	<input class="textInput" type="text" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField('{{$fieldName}}')}" id="{{$fieldId}}" />
{{/if}}

{{if $field.input.type != 'parsed' && $field.input.type != 'none'}}
	{formhelp note="{{$field.help}}"}
	{/forminput}
{{/if}}
