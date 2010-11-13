{strip}
{{include file="smarty_file_header.tpl"}}

{* service template wrapper for displaying different sections defined by this plugin *}
{{foreach from=$config.sections key=sectionName item=section}}
{if $smarty.request.section eq '{{$sectionName}}'}
	{if $smarty.request.action eq 'edit'}
{{if $section.modes && in_array('edit',$section.modes)}}
{{* include typemaps listed *}}
{{if $section.typemaps}}
{{foreach from=$section.typemaps item=typemapName}} 
{{if $config.typemaps.$typemapName}}
		{include file="bitpackage:{{$config.package}}/{{$config.name}}/edit_{{$typemapName}}_inc.tpl" serviceHash=$gContent->mInfo}
{{/if}}
{{/foreach}}
{{* default include typemap with same name *}}
{{elseif $config.typemaps.$sectionName}}
		{include file="bitpackage:{{$config.package}}/{{$config.name}}/edit_{{$sectionName}}_inc.tpl" serviceHash=$gContent->mInfo}
{{/if}}
{{/if}}
	{else}
{{if !$section.modes || in_array('view',$section.modes)}}
		{include file="bitpackage:{{$config.package}}/{{$config.name}}/display_{{$sectionName}}_inc.tpl" serviceHash=$gContent->mInfo}
{{/if}}
	{/if}
{/if}
{{/foreach}}
{/strip}
