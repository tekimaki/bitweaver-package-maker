{* Default *}
		<input class="textInput" type="text" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}}" />
