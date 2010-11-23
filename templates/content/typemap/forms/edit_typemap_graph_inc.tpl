{strip}
<div class="row" id="row_{{$typemapName}}_{{$field.field}}">
	{formlabel label="{{$field.name}}" class="label"}
	{forminput}
		{{* tail *}}
		{{assign var=field value=$typemap.graph.tail}}
		{{if !$field.input.value.object }}
		<ul id="{{$config.plugin}}_{{$typemapName}}_multiform">
		{{assign var=namespace value="`$config.name`[`$typemapName`]"}}
		{foreach from=${{$field.input.optionsHashName}} key=optionId item=optionTitle name=options}
			<li><label for="{{$namespace}}[{{$field.field}}][]"><input type="checkbox" id="{{$fieldId}}" name="{{$namespace}}[{{$field.field}}][]" value="{$optionId}"  {if $pObject->mInfo.{{$typemapName}}.$optionsId}checked="checked"{/if}/>&nbsp;{$optionTitle}</label></li>
		{/foreach}
		</ul>
		{{/if}}

		{{* head *}}
		{{assign var=field value=$typemap.graph.head}}
		{{if !$field.input.value.object }}
		<ul id="{{$config.plugin}}_{{$typemapName}}_multiform">
		{{assign var=namespace value="`$config.name`[`$typemapName`]"}}
		{foreach from=${{$field.input.optionsHashName}} key=optionId item=optionTitle name=options}
			<li><label for="{{$namespace}}[{{$field.field}}][]"><input type="checkbox" id="{{$fieldId}}" name="{{$namespace}}[{{$field.field}}][]" value="{$optionId}"  {if $pObject->mInfo.{{$typemapName}}.$optionsId}checked="checked"{/if}/>&nbsp;{$optionTitle}</label></li>
		{/foreach}
		</ul>
		{{/if}}
	{/forminput}
</div>
{/strip}
