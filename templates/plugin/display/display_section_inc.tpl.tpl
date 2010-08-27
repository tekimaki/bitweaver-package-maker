<div class="header">
{{* @TODO this is a little ugly to just get the title *}}
{{foreach from=$section.fields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}
{{if $typemapName eq 'liberty' && $fieldName eq 'title'}}
<h1>{$gContent->getTitle()}</h1>
{{/if}}
{{/foreach}}
{{/foreach}}
</div>
<div class="body">
{{foreach from=$section.fields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}
{{if $typemapName != 'liberty' && $fieldName != 'title'}}
{{* @TODO may need to namespace plugin fields *}}
{{* @TODO need to run parseData on soem fields *}}
<div>
{{if $field.input.type == "parsed"}}
{$gContent->mInfo['parsed_{{$fieldName}}')]}
{{else}}
{$gContent->mInfo['{{$fieldName}}']}
{{/if}}
</div>
{{/if}}
{{/foreach}}
{{/foreach}}
</div>
