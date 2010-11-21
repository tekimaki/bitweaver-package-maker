<ul>
		{{foreach from=$field.validator.choices item=choice}}
		<li><label for="{{$namespace}}[{{$fieldName}}]"><input type="radio" name="{{$namespace}}[{{$fieldName}}]" id="{{$fieldId}}" value="{{$choice}}" {if {{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}}}checked="checked"{/if}/>&nbsp;{{$choice}}</label></li>
		{{/foreach}}
		</ul>