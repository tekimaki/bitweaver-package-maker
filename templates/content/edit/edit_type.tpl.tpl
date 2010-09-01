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
		{formfeedback warning=$errors}
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
				{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_tab_tpl" display_help_tab=1}
			{/jstabs}
			</div>
			<div class="editcontainer">
			{jstabs}
				{if $preview eq 'y'}
					{jstab title="Preview"}
						{legend legend="Preview"}
						<div class="preview">
							{include file="bitpackage:{{$package}}/display_{{$type.name}}.tpl" page=`$gContent->mInfo.{{$type.name}}_id`}
						</div>
						{/legend}
					{/jstab}
				{/if}
				{jstab title="Edit"}
				{legend legend=$gContent->getContentTypeName()}
						<input type="hidden" name="{{$type.name}}[{{$type.name}}_id]" value="{$gContent->mInfo.{{$type.name}}_id}" />
						{formfeedback warning=$errors.store}

{{if $type.title}}
						<div class="row" id="row_title">
							{formfeedback warning=$errors.title}
							{formlabel label="{{$type.fields.title.name|default:'Title'}}" for="title"}
							{forminput}
								<input type="text" size="50" name="{{$type.name}}[title]" id="title" value="{$gContent->mInfo.title|escape}" />
							{/forminput}
						</div>
{{/if}}
{{foreach from=$type.fields key=fieldName item=field name=fields}}
{{if $field.validator.type != 'no-input' && $fieldName != 'data' && $fieldName != 'summary' && $fieldName !='title'}}
						<div class="row" id="row_{{$type.name}}_{{$fieldName}}" style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}">
							{{include file="edit_field.tpl"}}
						</div>
{{/if}}
{{/foreach}}
{{if $type.data}}
						{textarea label="{{$type.fields.data.name}}" name="{{$type.name}}[edit]" help="{{$type.fields.data.help}}"}{$gContent->mInfo.data}{/textarea}
{{/if}}
						{* any simple service edit options *}
						{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_mini_tpl"}

{{if !empty($type.attachments)}}

						{if $gBitUser->hasPermission('p_liberty_attach_attachments') }
							<div class=row>
							{legend legend="Attachments"}
								{include file="bitpackage:liberty/edit_storage.tpl"}
							{/legend}
							</div>
						{/if}

{{/if}}

						<div class="row submit">
							<input type="submit" name="preview" value="{tr}Preview{/tr}" />
							<input type="submit" name="save_{{$type.name}}" value="{tr}Save{/tr}" />
						</div>
					{/legend}
				{/jstab}
			{/jstabs}
			</div>
		{/form}
	</div><!-- end .body -->
</div><!-- end .{{$sample.class}} -->

{/strip}
