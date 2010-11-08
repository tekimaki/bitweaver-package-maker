{{if $service.relation == "one-to-one"}}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
	// Parse the {{$fieldName}}
	$parseHash['data'] = $pObject->mInfo['{{$fieldName}}'];
	$parseHash['cache_extension'] = "{{$serviceName}}_{{$fieldName}}";
	$pObject->mInfo['parsed_{{$fieldName}}'] = $pObject->parseData($parseHash);
{{/if}}
{{/foreach}}
{{/if}}
{{include file="custom_content_load_inc.php.tpl"}}
