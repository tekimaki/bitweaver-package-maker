	/**
	 * prep{{$typemapName|ucfirst}}Verify prepares the object for input verification
	 */
	function prep{{$typemapName|ucfirst}}Verify($pParamHash) {
		if (empty($this->mVerification['{{$type.name}}_{{$typemapName}}'])) {

{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
	 		/* Validation for {{$fieldName}} */
{{if !empty($field.validator.type) && $field.validator.type != "no-input"}}
			$this->mVerification['{{$type.name}}_{{$typemapName}}']['{{$field.validator.type}}']['{{$fieldName}}'] = array(
				'name' => '{{$field.name|default:$fieldName|addslashes}}',
{{foreach from=$field.validator key=k item=v name=keys}}
{{if $k != 'type'}}
				'{{$k}}' => {{if is_array($v)}}array(
{{foreach from=$v key=vk item=vv name=values}}
					{{if is_numeric($vk)}}{{$vk}}{{else}}'{{$vk}}'{{/if}} => '{{$vv}}'{{if !$smarty.foreach.values.last}},{{/if}}

{{/foreach}}
					){{else}}'{{$v}}'{{/if}}{{if !$smarty.foreach.keys.last}},{{/if}}

{{/if}}
{{/foreach}}
			);
{{elseif empty($field.validator.type)}}
			$this->mVerification['{{$type.name}}_{{$typemapName}}']['null']['{{$fieldName}}'] = TRUE;
{{/if}}
{{/foreach}}

		}
	}
