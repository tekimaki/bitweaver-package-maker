{legend legend="{{$section.title}}"}
{{foreach from=$section.typemaps item=typemapName name=typemaps}}
	{include file="bitpackage:{{$config.package}}/{{$config.name}}/edit_{{$typemapName}}_inc.tpl"}
{{/foreach}}
{/legend}
