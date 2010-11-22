<div class="body">
{{foreach from=$section.bodyfields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}
{{* field column match *}}
{{if $config.typemaps.$typemapName.fields.$fieldName}}
<div>
{{* @TODO may need to namespace plugin fields *}}
{{* @TODO need to run parseData on soem fields *}}
{{if $config.typemaps.$typemapName.fields.$fieldName.input.type == "parsed"}}
{$gContent->mInfo.parsed_{{$fieldName}}}
{{else}}
{$gContent->mInfo.{{$fieldName}}}
{{/if}}
</div>
{{* attachment match *}}
{{elseif $config.typemaps.$typemapName.attachments.$fieldName}}
<div>
	{attachment id=$gContent->mInfo.{{$fieldName}}_id}
</div>
{{/if}}
{{/foreach}}
{{/foreach}}
{* =-=- CUSTOM BEGIN: body -=-= *}
{{if !empty($customBlock.body)}}
{{$customBlock.body}}
{{else}}

{{/if}}
{* =-=- CUSTOM END: body -=-= *}
</div>
