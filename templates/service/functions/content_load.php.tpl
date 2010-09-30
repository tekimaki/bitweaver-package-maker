{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == "one-to-one"}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
{{if $typemap.relation == "one-to-one"}}
        // Parse the {{$fieldName}}
        $parseHash['data'] = $pObject->mInfo['{{$fieldName}}'];
        $parseHash['cache_extension'] = "{{$typemapName}}_{{$fieldName}}";
        $pObject->mInfo['parsed_{{$fieldName}}'] = $pObject->parseData($parseHash);
{{/if}}
{{/if}}
{{/foreach}}
{{/if}}
{{/foreach}}
{{include file="custom_content_load_inc.php.tpl"}}
