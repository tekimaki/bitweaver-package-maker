<textarea id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" rows="{{$field.input.rows|default:"20"}}">{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}</textarea>