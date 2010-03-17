{literal}{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='nav' serviceHash=$gContent->mInfo}
<div class="display {/literal}{$package} {$render.class}{literal}">
	<div class="floaticon">
		{if $print_page ne 'y'}
			{if $gContent->hasUpdatePermission()}
				<a title="{tr}Edit this {/literal}{$render.class}{literal}{/tr}" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}edit.php?{/literal}{$render.class}{literal}_id={$gContent->mInfo.{/literal}{$render.class}{literal}_id}">{biticon ipackage="icons" iname="accessories-text-editor" iexplain="Edit {/literal}{$render.class|capitalize}{literal}"}</a>
			{/if}
			{if $gContent->hasExpungePermission()}
				<a title="{tr}Remove this {/literal}{$render.class}{literal}{/tr}" href="{$smarty.const.{/literal}{$PACKAGE}{literal}_PKG_URL}remove_{/literal}{$render.class}{literal}.php?{/literal}{$render.class}{literal}_id={$gContent->mInfo.{/literal}{$render.class}{literal}_id}">{biticon ipackage="icons" iname="edit-delete" iexplain="Remove {/literal}{$render.class|capitalize}{literal}"}</a>
			{/if}
		{/if}<!-- end print_page -->
	</div><!-- end .floaticon -->

	<div class="header">
		<h1>{$gContent->mInfo.title|escape|default:"{/literal}{$render.class|capitalize}{literal}"}</h1>

		TODO: Other fields here!

		<div class="date">
			{tr}Created by{/tr}: {displayname user=$gContent->mInfo.creator_user user_id=$gContent->mInfo.creator_user_id real_name=$gContent->mInfo.creator_real_name}, {tr}Last modification by{/tr}: {displayname user=$gContent->mInfo.modifier_user user_id=$gContent->mInfo.modifier_user_id real_name=$gContent->mInfo.modifier_real_name}, {$gContent->mInfo.last_modified|bit_long_datetime}
		</div>
	</div><!-- end .header -->

	<div class="body">
		<div class="content">
			{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='body' serviceHash=$gContent->mInfo}
			{$gContent->mInfo.parsed_data}
		</div><!-- end .content -->
	</div><!-- end .body -->
</div><!-- end .{/literal}{$render.class}{literal} -->
{include file="bitpackage:liberty/services_inc.tpl" serviceLocation='view' serviceHash=$gContent->mInfo}
{/literal}