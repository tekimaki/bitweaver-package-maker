'{{$tableName}}' => "
{{foreach from=$table.fields key=fieldName item=field name=fields}}
		{{$fieldName}} {{$field.schema.type}}{{if !empty($field.schema.notnull)}} NOTNULL{{/if}}{{if !empty($field.schema.default)}} DEFAULT '{{$field.schema.default}}'{{/if}}{{if !empty($field.schema.unique)}} UNIQUE{{/if}}{{if !empty($field.schema.primary)}} PRIMARY{{/if}}{{if !$smarty.foreach.fields.last}},{{/if}}

{{/foreach}}{{if !empty($table.constraints) }}
        CONSTRAINT '
{{foreach from=$table.constraints item=constraint}}
        , {{$constraint}}
{{/foreach}}
        '
{{/if}}
    ",

