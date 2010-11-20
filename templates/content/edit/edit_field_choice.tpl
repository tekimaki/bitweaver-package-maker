<select name="{{$namespace}}[{{$fieldName}}]" id="{{$fieldId}}" {{if $field.validator.multiple}}multiple="multiple" size=3{{/if}}>
		{{foreach from=$field.validator.choices item=choice}}
		<option>{{$choice}}</option>
		{{/foreach}}
	    </select>