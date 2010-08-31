'{{$tablePrefix}}_{{$typemapName}}' => "
{{if $typemap.sequence}}
        {{$typemapName}}_id I4 PRIMARY,
{{/if}}
{{if $type.base_package == "liberty" || $typemap.base_table == 'liberty_content'}}
		content_id I4 NOTNULL{{if $typemap.fields.content_id.schema.primary}} PRIMARY{{/if}},
{{/if}}
{{foreach from=$typemap.attachments item=attachment name=attachments}}
		{{$typemapName}}_{{$attachment}}_id I4{{if !$smarty.foreach.attachments.last || !empty($typemap.fields)}},{{/if}}
{{/foreach}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id'}}
        {{$fieldName}} {{$field.schema.type}}{{if !empty($field.schema.notnull)}} NOTNULL{{/if}}{{if !empty($field.schema.default)}} DEFAULT '{{$field.schema.default}}'{{/if}}{{if !empty($field.schema.unique)}} UNIQUE{{/if}}{{if !$smarty.foreach.fields.last}},{{/if}}{{/if}}

{{/foreach}}{{if !empty($typemap.attachments) || !empty($typemap.constraints) || $type.base_package == "liberty" || $typemap.base_table == "liberty_content"}}
        CONSTRAINT '
{{if $type.base_package == "liberty" || $typemap.base_table == "liberty_content"}}
        , CONSTRAINT `{{$typemapName}}_content_ref` FOREIGN KEY (`content_id`) REFERENCES `liberty_content` (`content_id`)
{{/if}}
{{foreach from=$typemap.attachments item=attachment name=attachments}}
        , CONSTRAINT `{{$typemapName}}_{{$attachment}}_attch_ref` FOREIGN KEY (`{{$typemapName}}_{{$attachment}}_id`) REFERENCES `liberty_attachments` (`attachment_id`)
{{/foreach}}
{{foreach from=$typemap.constraints item=constraint}}
        , {{$constraint}}
{{/foreach}}
        '
{{/if}}
    ",

