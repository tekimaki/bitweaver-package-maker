{* Hidden *}
<input type="hidden" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />