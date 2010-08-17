{strip}
{{include file="bitpackage:pkgmkr/smarty_file_header.tpl}}
{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='nav' serviceHash=$gContent->mInfo}
<div class="display {{$package}} {{$type.name}}">
	<div class="floaticon">
		{if $print_page ne 'y'}
			{* =-=- CUSTOM BEGIN: icons -=-= *}
{{if !empty($customBlock.icons)}}
{{$customBlock.icons}}
{{else}}

{{/if}}
			{* =-=- CUSTOM END: icons -=-= *}
			{if $gContent->hasUpdatePermission()}
				<a title="{tr}Edit this {$gContent->getContentTypeName()|strtolower}{/tr}" href="{$smarty.const.{{$PACKAGE}}_PKG_URL}edit_{{$type.name}}.php?{{$type.name}}_id={$gContent->mInfo.{{$type.name}}_id}">{biticon ipackage="icons" iname="accessories-text-editor" iexplain="Edit `$gContent->mType.content_name`"}</a>
			{/if}
			{if $gContent->hasExpungePermission()}
				<a title="{tr}Remove this {$gContent->getContentTypeName()|strtolower}{/tr}" href="{$smarty.const.{{$PACKAGE}}_PKG_URL}remove_{{$type.name}}.php?{{$type.name}}_id={$gContent->mInfo.{{$type.name}}_id}">{biticon ipackage="icons" iname="edit-delete" iexplain="Remove {{$type.name|capitalize}}"}</a>
			{/if}
		{/if}<!-- end print_page -->
	</div><!-- end .floaticon -->

	<div class="header">
		<h1>{$gContent->mInfo.title|escape|default:$gContent->getContentTypeName()}</h1>

		<div class="date">
			{tr}Created by{/tr}: {displayname user=$gContent->mInfo.creator_user user_id=$gContent->mInfo.creator_user_id real_name=$gContent->mInfo.creator_real_name}, {tr}Last modification by{/tr}: {displayname user=$gContent->mInfo.modifier_user user_id=$gContent->mInfo.modifier_user_id real_name=$gContent->mInfo.modifier_real_name}, {$gContent->mInfo.last_modified|bit_long_datetime}
		</div>
		{* =-=- CUSTOM BEGIN: header -=-= *}
{{if !empty($customBlock.header)}}
{{$customBlock.header}}
{{else}}

{{/if}}
		{* =-=- CUSTOM END: header -=-= *}
	</div><!-- end .header -->

	<div class="body">
		<div class="content">
			{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='body' serviceHash=$gContent->mInfo}
			{* =-=- CUSTOM BEGIN: body -=-= *}
{{if !empty($customBlock.body)}}
{{$customBlock.body}}
{{else}}

{{/if}}
			{* =-=- CUSTOM END: body -=-= *}


{{foreach from=$type.fields key=fieldName item=field name=fields}}{{if $fieldName != 'data'}}
			<div class="row {{$fieldName}}">
				<label>{{$field.name|capitalize}}:</label>&nbsp;{$gContent->getField('{{$fieldName}}')|escape}
			</div>
{{/if}}{{/foreach}}

{{if $type.data}}
			{$gContent->mInfo.parsed_data}
{{/if}}


		</div><!-- end .content -->
	</div><!-- end .body -->
</div><!-- end .{{$type.name}} -->
{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='view' serviceHash=$gContent->mInfo}
{/strip}
