{{**
@param $typemapName
@param $fieldName
@param $field
*}}
{{* This is support for one-to-many content types where 
	multiple copies of the same input might be in the form 
	This shit is seriously complicated to render *}}
{{if $index}}
{{assign var=fieldId value=$fieldName|cat:'_{$index}'}}
{{if $field.input.default}}
{{assign var=inputValue value='{$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`|default:`$field.input.default`}"}}
{{assign var=inputValueAlt value='$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`|default:`$field.input.default`"}}
{{assign var=inputValueDesc value='{$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`_desc}"}}
{{else}}
{{assign var=inputValue value='{$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`}"}}
{{assign var=inputValueAlt value='$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`"}}
{{assign var=inputValueDesc value='{$gContent->mInfo.'|cat:"`$typemapName`."|cat:'$index'|cat:".`$fieldName`_desc}"}}
{{/if}}
{{else}}{{* no index *}}
{{assign var=fieldId value=$fieldName}}
{{/if}}

{{if $field.input.type != 'parsed' && $field.input.type != 'none' && $field.input.type != 'hidden' && $field.input.type != 'reference'}}
	{formlabel label="{{$field.name}}" for="{{$fieldName}}" {{if $field.validator.required}}required="y"{{/if}}}
	{forminput}
{{if $plugin}}
{{if $index}}
		{formfeedback error=$errors.{{$plugin}}.{{$typemapName}}.$index.{{$fieldName}}}
{{else}}
		{formfeedback error=$errors.{{$plugin}}.{{$typemapName}}.{{$fieldName}}}
{{/if}}
{{elseif $typemapName}}
		{formfeedback error=$errors.{{$typemapName}}.{{$fieldName}}}
{{else}}
		{formfeedback error=$errors.{{$fieldName}}}
{{/if}}
{{/if}}

{{if !empty($field.input.type)}}
    {{if !$namespace}}{{assign var=namespace value=$type.name}}{{/if}}
    {{if $field.input.type=="none"}}
	{* No input for {{$field.name}} *}
    {{else}}
	{{assign var=fieldTemplate value="edit_field_"|cat:$field.input.type|cat:".tpl"}}
	{{include file=$fieldTemplate}}
    {{/if}}
{{else}}
	{* No input type *}
	<input class="textInput" type="text" name="{{$namespace}}[{{$fieldName}}]" value="{$gContent->getField('{{$fieldName}}')}" id="{{$fieldId}}" />
{{/if}}

{{if $field.input.type != 'parsed' && $field.input.type != 'none' && $field.input.type != 'hidden' && $field.input.type != "reference" }}
	{formhelp note="{{$field.help}}"}
	{/forminput}
{{/if}}
