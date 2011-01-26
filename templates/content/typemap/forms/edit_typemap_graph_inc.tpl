{{* tail *}}
{{if !$typemap.graph.tail.value.object}}
{{assign var=field value=$typemap.graph.tail}}
{{assign var=fieldType value=tail}}
{{* head *}}
{{elseif !$typemap.graph.head.value.object}}
{{assign var=field value=$typemap.graph.head}}
{{assign var=fieldType value=head}}
{{/if}}
{{assign var=namespace value="`$config.name`[`$typemapName`]"}}
{strip}
<div class="row" id="row_{{$typemapName}}_{{$field.field}}">
	{formlabel label="{{$field.name}}" class="label"}
	{forminput}
{{* input type: select *}}
{{if $field.input.type eq 'select'}}
{{* @TODO - support for one to one? *}}
{{if $typemap.validate.max}}
	<ul id="{{$config.plugin}}_{{$typemapName}}_multiform">
	{section name="{{$typemapName}}_{{$field.field}}" loop={{$typemap.validate.max}} start=0}
		<li>{html_options id="row_{{$typemapName}}_{{$field.field}}" options=${{$typemapName}}_{{$field.input.optionsHashName}} name="{{$namespace}}[`$smarty.section.{{$typemapName}}_{{$field.field}}.index`][{{$fieldType}}_content_id]" selected=$gContent->mInfo.{{$typemapName}}.{{$field.field}}[$smarty.section.{{$typemapName}}_{{$field.field}}.index] {{foreach from=$field.input.jshandlers key=event item=handlerName}}{{$event}}="{{$handlerName}}(this);" {{/foreach}}}</li>
	{/section}
	</ul>
{{/if}}

{{* input type: checkbox *}}
{{elseif $field.input.type eq 'checkbox'}}
		<ul id="{{$config.plugin}}_{{$typemapName}}_multiform">
{{assign var=namespace value="`$config.name`[`$typemapName`]"}}
		{foreach from=${{$typemapName}}_{{$field.input.optionsHashName}} key=optionId item=optionTitle name=options}
			<li><label for="{{$namespace}}[{$optionId}][{{$fieldType}}_content_id]"><input type="checkbox" id="{{$fieldId}}" name="{{$namespace}}[{$optionId}][{{$fieldType}}_content_id]" value="{$optionId}"  {if $gContent->mInfo.{{$typemapName}}.{{$field.field}}.$optionId}checked="checked"{/if}/>&nbsp;{$optionTitle}</label></li>
		{/foreach}
		</ul>
{{/if}}
	{formhelp note="{{$field.help}}"}
	{/forminput}
</div>
{/strip}
