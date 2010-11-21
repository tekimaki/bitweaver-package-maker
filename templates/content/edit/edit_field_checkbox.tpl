<ul>
		{{foreach from=$field.validator.choices item=choice}}
		<li><label for="{{$namespace}}[{{$fieldName}}]"><input type="checkbox" id="{{$fieldId}}" name="{{$namespace}}[{{$fieldName}}]" value="{{$choice}}" {if {{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}}}checked="checked"{/if}/>&nbsp;{{$choice}}</label></li>
		{{/foreach}}
		</ul>