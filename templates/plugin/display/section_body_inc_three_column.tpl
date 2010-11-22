<div class="body">

<div class="section-col1">
{{foreach from=$section.bodyfields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}

{{if $config.typemaps.$typemapName.modifier && in_array('section-col1', $config.typemaps.$typemapName.modifier)}}
{{* column match 1 *}}

{if $gContent->mInfo.{{$typemapName}}_slideshow}
{slideshow imagesHash=$gContent->mInfo.{{$typemapName}}_slideshow rel={{$typemapName}}}
{else}
<img src="{$smarty.const.THEMES_PKG_URL}icons/default-leftside-col.jpg"  width="150px" height="150px"/>
{/if}
{{/if}}
{{/foreach}}
{{/foreach}}
</div>

{{* column match 2 *}}
<div class="section-col2">
{{foreach from=$section.bodyfields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}
{{if $config.typemaps.$typemapName.modifier && in_array('section-col2', $config.typemaps.$typemapName.modifier)}}
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
{{/if}}
{{/foreach}}
{{/foreach}}
</div>

{{* column match 3 *}}
<div class="section-col3">
{{foreach from=$section.bodyfields item=field}}
{{foreach from=$field key=typemapName item=fieldName}}
{{if  $config.typemaps.$typemapName.modifier && in_array('section-col3', $config.typemaps.$typemapName.modifier)}}
{if $gContent->mInfo.{{$typemapName}}}
<legend> {{$config.typemaps.$typemapName.label}}</legend>
<div>
<ul>
{foreach from=$gContent->mInfo.{{$typemapName}} key=link_content_id item=link}
{{if  $config.typemaps.$typemapName.modifier && in_array('download', $config.typemaps.$typemapName.modifier)}}
<li><a href="{$smarty.const.LIBERTY_PKG_URL}download/file/{$link.{{$config.name}}_related_doc_id}">{$link.{{$config.name}}_related_title}</a></li>
{{else if  $config.typemaps.$typemapName.modifier && in_array('link', $config.typemaps.$typemapName.modifier)}}
<li><a href="{$link.{{$config.name}}_related_link_url}">{$link.{{$config.name}}_related_link_title}</a></li>
{{/if}}
{/foreach}
</ul>
</div>
{/if}
{{/if}}
{{/foreach}}
{{/foreach}}
</div>
{* =-=- CUSTOM BEGIN: body -=-= *}
{{if !empty($customBlock.body)}}
{{$customBlock.body}}
{{else}}

{{/if}}
{* =-=- CUSTOM END: body -=-= *}
</div>