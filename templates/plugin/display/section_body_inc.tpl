<div class="body">
{{foreach from=$section.bodyfields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}
<div>
{{* @TODO may need to namespace plugin fields *}}
{{* @TODO need to run parseData on soem fields *}}
{{if $field.input.type == "parsed"}}
{$gContent->mInfo.parsed_{{$fieldName}}}
{{else}}
{$gContent->mInfo.{{$fieldName}}}
{{/if}}
</div>
{{/foreach}}
{{/foreach}}
{* =-=- CUSTOM BEGIN: body -=-= *}
{{if !empty($customBlock.body)}}
{{$customBlock.body}}
{{else}}

{{/if}}
{* =-=- CUSTOM END: body -=-= *}
</div>
