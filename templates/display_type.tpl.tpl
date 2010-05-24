{literal}{strip}
{/literal}{include file="bitpackage:pkgmkr/smarty_file_header.tpl}{literal}
{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='nav' serviceHash=$gContent->mInfo}
<div class="display {/literal}{$package} {$type.name}{literal}">
	<div class="floaticon">
		{if $print_page ne 'y'}
			{* =-=- CUSTOM BEGIN: icons -=-= *}
{/literal}{if !empty($customBlock.icons)}
{$customBlock.icons}
{else}

{/if}{literal}
			{* =-=- CUSTOM END: icons -=-= *}
			{if $gContent->hasUpdatePermission()}
				<a title="{tr}Edit this {$gContent->getContentTypeName()|strtolower}{/tr}" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}edit_{/literal}{$type.name}{literal}.php?{/literal}{$type.name}{literal}_id={$gContent->mInfo.{/literal}{$type.name}{literal}_id}">{biticon ipackage="icons" iname="accessories-text-editor" iexplain="Edit `$gContent->mType.content_name`"}</a>
			{/if}
			{if $gContent->hasExpungePermission()}
				<a title="{tr}Remove this {$gContent->getContentTypeName()|strtolower}{/tr}" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}remove_{/literal}{$type.name}{literal}.php?{/literal}{$type.name}{literal}_id={$gContent->mInfo.{/literal}{$type.name}{literal}_id}">{biticon ipackage="icons" iname="edit-delete" iexplain="Remove {/literal}{$type.name|capitalize}{literal}"}</a>
			{/if}
		{/if}<!-- end print_page -->
	</div><!-- end .floaticon -->

	<div class="header">
		<h1>{$gContent->mInfo.title|escape|default:$gContent->getContentTypeName()}</h1>

		<div class="date">
			{tr}Created by{/tr}: {displayname user=$gContent->mInfo.creator_user user_id=$gContent->mInfo.creator_user_id real_name=$gContent->mInfo.creator_real_name}, {tr}Last modification by{/tr}: {displayname user=$gContent->mInfo.modifier_user user_id=$gContent->mInfo.modifier_user_id real_name=$gContent->mInfo.modifier_real_name}, {$gContent->mInfo.last_modified|bit_long_datetime}
		</div>
		{* =-=- CUSTOM BEGIN: header -=-= *}
{/literal}{if !empty($customBlock.header)}
{$customBlock.header}
{else}

{/if}{literal}
		{* =-=- CUSTOM END: header -=-= *}
	</div><!-- end .header -->

	<div class="body">
		<div class="content">
			{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='body' serviceHash=$gContent->mInfo}
			{* =-=- CUSTOM BEGIN: body -=-= *}
{/literal}{if !empty($customBlock.body)}
{$customBlock.body}
{else}

{/if}{literal}
			{* =-=- CUSTOM END: body -=-= *}

{/literal}
{foreach from=$type.fields key=fieldName item=field name=fields}{if $fieldName != 'data'}
			<div class="row {$fieldName}">
				<label>{$field.name|capitalize}:</label>&nbsp;{ldelim}$gContent->getField('{$fieldName}')|escape{rdelim}
			</div>
{/if}{/foreach}

{if $type.data}{literal}
			{$gContent->mInfo.parsed_data}
{/literal}{/if}
{literal}

		</div><!-- end .content -->
	</div><!-- end .body -->
</div><!-- end .{/literal}{$type.name}{literal} -->
{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='view' serviceHash=$gContent->mInfo}
{/strip}{/literal}
