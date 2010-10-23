{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}: |
{{if $service.sequence}}
        {{$serviceName}}_id I4 PRIMARY,
{{/if}}
{{if $service.base_package == "liberty"}}
        content_id I4 NOTNULL,
{{/if}}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
{{if $field.validator.type == "reference"}}{{assign var=field_has_reference value=1}}{{/if}}
        {{$fieldName}} {{$field.schema.type}}{{if !empty($field.schema.notnull)}} NOTNULL{{/if}}{{if !empty($field.schema.default)}} DEFAULT '{{$field.schema.default}}'{{/if}}{{if !empty($field.schema.unique)}} UNIQUE{{/if}}{{if !empty($field.schema.primary)}} PRIMARY{{/if}}{{if !$smarty.foreach.fields.last}},{{/if}}

{{/foreach}}{{if $field_has_reference || !empty($service.constraints) || $service.base_package == "liberty"}}
        CONSTRAINT '
{{if $service.base_package == "liberty"}}
        , CONSTRAINT `{{$serviceName}}_content_ref` FOREIGN KEY (`content_id`) REFERENCES `liberty_content` (`content_id`)
{{/if}}
{{if $field_has_reference}}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
{{if $field.validator.type == "reference"}}
		, CONSTRAINT `{{$serviceName}}_{{$fieldName}}_{{$field.validator.column}}_ref` FOREIGN KEY (`{{$fieldName}}`) REFERENCES `{{$field.validator.table}}` (`{{$field.validator.column}}`)
{{/if}}
{{/foreach}}
{{assign var=field_has_reference value=0}}
{{/if}}
{{foreach from=$service.constraints item=constraint}}
        , {{$constraint}}
{{/foreach}}
        '
{{/if}}


