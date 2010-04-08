{literal}{strip}
{/literal}{include file="bitpackage:pkgmkr/smarty_file_header.tpl}{literal}
<div class="floaticon">{bithelp}</div>

<div class="edit {/literal}{$package} {$type.name}{literal}">
	{if $smarty.request.preview}
		<h2>Preview {$gContent->mInfo.title|escape}</h2>
		<div class="preview">
			{include file="bitpackage:{/literal}{$package}{literal}/display_{/literal}{$type.name}{literal}.tpl" page=`$gContent->mInfo.{/literal}{$type.name}{literal}_id`}
		</div>
	{/if}

	<div class="header">
		<h1>
			{if $gContent->mInfo.{/literal}{$type.name}{literal}_id}
				{tr}Edit {$gContent->mInfo.title|escape}{/tr}
			{else}
				{tr}Create New {/literal}{$type.name|capitalize}{literal}{/tr}
			{/if}
		</h1>
	</div>

	<div class="body">
		{form enctype="multipart/form-data" id="edit{/literal}{$type.name}{literal}form"}
			{jstabs}
				{jstab title="{/literal}{$type.name|capitalize}{literal}"}
					{legend legend="{/literal}{$type.name|capitalize}{literal} Record"}
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
						<div class="row {$sample.class}_{$fieldName}">
							{ldelim}formfeedback warning=$errors.{$fieldName}{rdelim}
							{ldelim}formlabel label="{$field.name|capitalize}" for="{$fieldName}"{rdelim}
							{ldelim}forminput{rdelim}
								{include file="bitpackage:pkgmkr/edit_field.tpl"}
								{if $field.validator.required}{ldelim}required{rdelim}{/if}
								{ldelim}formhelp note="{$field.help}"{rdelim}
							{ldelim}/forminput{rdelim}
						</div>
{/foreach}
{literal}

						{textarea name="{/literal}{$type.name}{literal}[edit]"}{$gContent->mInfo.data}{/textarea}

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
				{* any service edit template tabs *}
				{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_tab_tpl"}
			{/jstabs}
		{/form}
	</div><!-- end .body -->
</div><!-- end .{/literal}{$sample.class}{literal} -->

{/strip}{/literal}
