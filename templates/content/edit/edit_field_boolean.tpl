<input type="checkbox" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" {if {{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}}}checked="checked"{/if}/>
