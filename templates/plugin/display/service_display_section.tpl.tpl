{strip}
{{include file="smarty_file_header.tpl"}}

{* service template wrapper for displaying different sections defined by this plugin *}
{{foreach from=$config.sections key=sectionName item=section}}
{if $smarty.request.section eq '{{$sectionName}}'}
	{include file="bitpackage:{{$config.package}}/{{$config.name}}/display_{{$sectionName}}_inc.tpl" serviceHash=$gContent->mInfo}
{/if}
{{/foreach}}
{/strip}
