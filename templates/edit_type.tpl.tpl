{literal}{strip}
{/literal}{include file="bitpackage:pkgmkr/smarty_file_header.tpl}{literal}
<div class="floaticon">{bithelp}</div>

<div class="edit {/literal}{$package} {$type.name}{literal}">
	<div class="header">
		<h1>
			{if $gContent->mInfo.{/literal}{$type.name}{literal}_id}
				{tr}Edit {$gContent->mInfo.title|escape}{/tr}
			{else}
				{tr}Create New {$gContent->getContentTypeName()}{/tr}
			{/if}
		</h1>
	</div>

	<div class="body">
		{formfeedback warning=$errors}
		{form enctype="multipart/form-data" id="edit{/literal}{$type.name}{literal}form"}
			{* =-=- CUSTOM BEGIN: input -=-= *}
{/literal}{if !empty($customBlock.input)}
{$customBlock.input}
{else}

{/if}{literal}
			{* =-=- CUSTOM END: input -=-= *}
			<input type="hidden" name="content_id" value="{$gContent->mContentId}" />
			<div class="servicetabs">
			{jstabs id="servicetabs"}
				{* =-=- CUSTOM BEGIN: servicetabs -=-= *}
{/literal}{if !empty($customBlock.servicetabs}
{$customBlock.servicetabs}
{else}

{/if}{literal}
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
							{include file="bitpackage:{/literal}{$package}{literal}/display_{/literal}{$type.name}{literal}.tpl" page=`$gContent->mInfo.{/literal}{$type.name}{literal}_id`}
						</div>
						{/legend}
					{/jstab}
				{/if}
				{jstab title="Edit"}
				{legend legend=$gContent->getContentTypeName()}
						<input type="hidden" name="{/literal}{$type.name}{literal}[{/literal}{$type.name}{literal}_id]" value="{$gContent->mInfo.{/literal}{$type.name}{literal}_id}" />
						{formfeedback warning=$errors.store}

						<div class="row">
							{formfeedback warning=$errors.title}
							{formlabel label="Title" for="title"}
							{forminput}
								<input type="text" size="50" name="{/literal}{$type.name}{literal}[title]" id="title" value="{$gContent->mInfo.title|escape}" />
							{/forminput}
						</div>
{/literal}
{foreach from=$type.fields key=fieldName item=field name=fields}
{if $field.validator.type != 'no-input' && $fieldName != 'data' && $fieldName != 'summary'}
						<div class="row" id="row_{$type.name}_{$fieldName}" style="{foreach from=$field.input.styles.row key=param item=value}{$param}:{$value};{/foreach}">
							{ldelim}formfeedback warning=$errors.{$fieldName}{rdelim}
							{ldelim}formlabel label="{$field.name|capitalize}" for="{$fieldName}"{rdelim}
							{ldelim}forminput{rdelim}
							{include file="bitpackage:pkgmkr/edit_field.tpl"}
							{if $field.validator.required}{ldelim}required{rdelim}
							{/if}{ldelim}formhelp note="{$field.help}"{rdelim}
							{ldelim}/forminput{rdelim}
						</div>
{/if}
{/foreach}
{if $type.data}{literal}
						{textarea label="{/literal}{$type.fields.data.name}{literal}" name="{/literal}{$type.name}{literal}[edit]" help="{/literal}{$type.fields.data.help}{literal}"}{$gContent->mInfo.data}{/textarea}
{/literal}{/if}{literal}
						{* any simple service edit options *}
						{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_mini_tpl"}

						<div class="row submit">
							<input type="submit" name="preview" value="{tr}Preview{/tr}" />
							<input type="submit" name="save_{/literal}{$type.name}{literal}" value="{tr}Save{/tr}" />
						</div>
{/literal}
{if $type.attachments}
{literal}
						{if $gBitUser->hasPermission('p_liberty_attach_attachments') }
							<div class=row>
							{legend legend="Attachments"}
								{include file="bitpackage:liberty/edit_storage.tpl"}
							{/legend}
							</div>
						{/if}
{/literal}
{/if}
{literal}
					{/legend}
				{/jstab}
			{/jstabs}
			</div>
		{/form}
	</div><!-- end .body -->
</div><!-- end .{/literal}{$sample.class}{literal} -->

{/strip}{/literal}
