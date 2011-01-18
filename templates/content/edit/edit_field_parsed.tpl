{textarea label="{{$field.name}}"
	{{if $plugin}}
	{{if $index}}
	error=$errors.{{$plugin}}.{{$typemapName}}.$index.{{$fieldName}}
	{{else}}
	error=$errors.{{$plugin}}.{{$typemapName}}.{{$fieldName}}
	{{/if}}
	{{elseif $typemapName}}
	error=$errors.{{$typemapName}}.{{$fieldName}}
	{{else}}
	error=$errors.{{$fieldName}}
	{{/if}}
	help="{{$field.help}}" noformat="true" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" rows="{{$field.input.rows|default:"20"}}" {{if $field.validator.required}}required="y"{{/if}}}{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}{/textarea}
