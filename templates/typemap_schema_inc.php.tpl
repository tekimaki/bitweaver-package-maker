'{{$tablePrefix}}_{{$typemapName}}' => "
{{if $typemap.sequence}}
        {{$typemapName}}_id I4 PRIMARY,
{{/if}}
{{if $type.base_package == "liberty"}}
        content_id I4 NOTNULL,
{{/if}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
        {{$fieldName}} {{$field.schema.type}}{{if !empty($field.schema.notnull)}} NOTNULL{{/if}}{{if !empty($field.schema.default)}} DEFAULT '{{$field.schema.default}}'{{/if}}{{if !empty($field.schema.unique)}} UNIQUE{{/if}}{{if !$smarty.foreach.fields.last}},{{/if}}

{{/foreach}}{{if !empty($typemap.constraints) || $type.base_package == "liberty"}}
        CONSTRAINT '
{{if $type.base_package == "liberty"}}
        , CONSTRAINT `{{$typemapName}}_content_ref` FOREIGN KEY (`content_id`) REFERENCES `liberty_content` (`content_id`)
{{/if}}
{{foreach from=$typemap.constraints item=constraint}}
        , {{$constraint}}
{{/foreach}}
        '
{{/if}}
    ",

