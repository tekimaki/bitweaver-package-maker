'{{$typeName}}_data' => "
{{if $type.base_package == "liberty"}}
		{{$typeName}}_id I4 PRIMARY,
		content_id I4 NOTNULL{{if $type.fields}},{{/if}} 
{{/if}}
{{foreach from=$type.fields key=fieldName item=field name=fields}}{{if $field.schema}}
        {{$fieldName}} {{$field.schema.type}}{{if !empty($field.schema.notnull)}} NOTNULL{{/if}}{{if !empty($field.schema.default)}} DEFAULT '{{$field.schema.default}}'{{/if}}{{if !empty($field.schema.unique)}} UNIQUE{{/if}}{{if !$smarty.foreach.fields.last}},{{/if}}

{{/if}}{{/foreach}}{{if !empty($type.constraints) || $type.base_package == "liberty"}}
        CONSTRAINT '
{{if $type.base_package == "liberty"}}
        , CONSTRAINT `{{$typeName}}_content_ref` FOREIGN KEY (`content_id`) REFERENCES `liberty_content` (`content_id`)
{{/if}}
{{foreach from=$type.constraints item=constraint}}
		, {{$constraint}}
{{/foreach}}
		'
{{/if}}
	",

