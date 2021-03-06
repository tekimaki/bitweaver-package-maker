{strip}
{{include file="smarty_file_header.tpl}}
<div class="floaticon">{bithelp}</div>

<div class="edit {{$package}} {{$type.name}}">
	<div class="header">
		<h1>
			{if $gContent->mInfo.{{$type.name}}_id}
				{tr}Edit {$gContent->mInfo.title|escape}{/tr}
			{else}
				{tr}Create New {$gContent->getContentTypeName()}{/tr}
			{/if}
		</h1>
	</div>

	<div class="body">
		{formfeedback success=$success}
		{formfeedback error=$errors.store}
		{form enctype="multipart/form-data" id="edit{{$type.name}}form"}
			{* =-=- CUSTOM BEGIN: input -=-= *}
{{if !empty($customBlock.input)}}
{{$customBlock.input}}
{{else}}

{{/if}}
			{* =-=- CUSTOM END: input -=-= *}
			<input type="hidden" name="content_id" value="{$gContent->mContentId}" />
			<div class="servicetabs">
			{jstabs id="servicetabs"}
				{* =-=- CUSTOM BEGIN: servicetabs -=-= *}
{{if !empty($customBlock.servicetabs)}}
{{$customBlock.servicetabs}}
{{else}}

{{/if}}
				{* =-=- CUSTOM END: servicetabs -=-= *}
				{* any service edit template tabs *}
				{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_tab_tpl" display_help_tab=1 formid="edit{{$type.name}}form"}
			{/jstabs}
			</div>
			<div class="editcontainer">
			{jstabs}
{{if !isset($type.preview) || $type.preview eq true}}
				{if $preview eq 'y'}
					{jstab title="Preview"}
						{legend legend="Preview"}
						<div class="preview">
							{include file="bitpackage:{{$package}}/display_{{$type.name}}.tpl" page=`$gContent->mInfo.{{$type.name}}_id`}
						</div>
						{/legend}
					{/jstab}
				{/if}
{{/if}}
				{jstab title="Edit"}
				{legend legend=$gContent->getContentTypeName() class="inlineLabels"}
						<input type="hidden" name="{{$type.name}}[{{$type.name}}_id]" value="{$gContent->mInfo.{{$type.name}}_id}" />

{{if $type.title}}
						<div class="row" id="row_title">
							{formlabel label="{{$type.fields.title.name|default:'Title'}}" for="title" {{if $type.fields.title.validator.required}}required="y"{{/if}}}
							{forminput}
								{formfeedback error=$errors.title}
								<input class="textInput" type="text" size="50" name="{{$type.name}}[title]" id="title" value="{$gContent->mInfo.title|escape}" />
							{/forminput}
						</div>
{{/if}}
{{foreach from=$type.fields key=fieldName item=field name=fields}}
{{if $field.input.type != 'none' && $field.validator.type != 'no-input' && $fieldName != 'data' && $fieldName != 'summary' && $fieldName !='title'}}
						<div class="row" id="row_{{$type.name}}_{{$fieldName}}" style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}">
							{{include file="edit_field.tpl"}}
						</div>
{{/if}}
{{/foreach}}
{{if $type.data}} 
{textarea label="{{$type.fields.data.name}}" name="{{$type.name}}[edit]" help="{{$type.fields.data.help}}" error=$errors.data {{if $type.fields.data.validator.required}}required="y"{{/if}}}{$gContent->mInfo.data}{/textarea}
{{/if}}
						{* any simple service edit options *}
						{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_mini_tpl" formid="edit{{$type.name}}form"}

{{if !empty($type.attachments)}}
{{if is_array($type.attachments) }} {{* array of specific attachments *}}
{{* trick it into processing as a typemap *}}
{{assign var=typemap value=$type}}
{{assign var=type.relation value='one-to-one'}}
{{assign var=typemapName value=$type.name}}
{{* Now handle all the attachments *}}
{{foreach from=$type.attachments item=prefs key=attachment no_upload_button=true}}
	{{include file=typemap_attachment_field.tpl}}
{{/foreach}}
{{else}}

						{if $gContent->hasUserPermission('p_liberty_attach_attachments') }
							<div class="row">
							{legend legend="Attachments"}
								{include file="bitpackage:liberty/edit_storage.tpl"}
							{/legend}
							</div>
						{/if}
{{/if}}
{{/if}}

						<div class="buttonHolder row submit">
{{if !isset($type.preview) || $type.preview eq true}}
							<input class="button" type="submit" name="preview" value="{tr}Preview{/tr}" />
{{/if}}
							<input class="button" type="submit" name="save_{{$type.name}}" value="{tr}Save{/tr}" />
						</div>
					{/legend}
				{/jstab}
			{/jstabs}
			</div>
		{/form}
	</div><!-- end .body -->
</div><!-- end .{{$sample.class}} -->

{/strip}
