<div class="header">
{{if $section.title}}
<h1>{{$section.title}}</h1>
{{/if}}
{{foreach from=$section.headerfields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}
{{* switch *}}
{{* if liberty title *}}
{{if $typemapName eq 'liberty' && $fieldName eq 'title'}}
<h1>{$gContent->getTitle()}</h1>
{{else}}
<div>
{{ * else any mInfo field *}}
{{* @TODO may need to namespace plugin fields *}}
{{* @TODO need to run parseData on soem fields *}}
{{if $field.input.type == "parsed"}}
{$gContent->mInfo.parsed_{{$fieldName}}}
{{else}}
{$gContent->mInfo.{{$fieldName}}}
{{/if}}
</div>
{{/if}}
{{* end switch *}}
{{/foreach}}
{{/foreach}}
{* =-=- CUSTOM BEGIN: header -=-= *}
{{if !empty($customBlock.header)}}
{{$customBlock.header}}
{{else}}

{{/if}}
{* =-=- CUSTOM END: header -=-= *}
</div>
