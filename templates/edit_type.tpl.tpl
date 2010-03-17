{literal}{strip}
<div class="floaticon">{bithelp}</div>

<div class="edit {/literal}{$package} {$render.class}{literal}">
	{if $smarty.request.preview}
		<h2>Preview {$gContent->mInfo.title|escape}</h2>
		<div class="preview">
			{include file="bitpackage:{/literal}{$package}{literal}/display_{/literal}{$render.class}{literal}.tpl" page=`$gContent->mInfo.{/literal}{$render.class}{literal}_id`}
		</div>
	{/if}

	<div class="header">
		<h1>
			{if $gContent->mInfo.{/literal}{$render.class}{literal}_id}
				{tr}Edit {$gContent->mInfo.title|escape}{/tr}
			{else}
				{tr}Create New {/literal}{$render.class|capitalize}{literal}{/tr}
			{/if}
		</h1>
	</div>

	<div class="body">
		{form enctype="multipart/form-data" id="edit{/literal}{$render.class}{literal}form"}
			{jstabs}
				{jstab title="Record"}
					{legend legend="{/literal}{$render.class|capitalize}{literal} Record"}
						<input type="hidden" name="{/literal}{$render.class}{literal}[{/literal}{$render.class}{literal}_id]" value="{$gContent->mInfo.{/literal}{$render.class}{literal}_id}" />
						{formfeedback warning=$errors.store}

						<div class="row">
							{formfeedback warning=$errors.title}
							{formlabel label="Title" for="title"}
							{forminput}
								<input type="text" size="50" name="{/literal}{$render.class}{literal}[title]" id="title" value="{$gContent->mInfo.title|escape}" />
							{/forminput}
						</div>

						TODO: OTHER FIELDS HERE

						{textarea name="{/literal}{$render.class}{literal}[edit]"}{$gContent->mInfo.data}{/textarea}

						{* any simple service edit options *}
						{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_mini_tpl"}

						<div class="row submit">
							<input type="submit" name="preview" value="{tr}Preview{/tr}" />
							<input type="submit" name="save_{/literal}{$render.class}{literal}" value="{tr}Save{/tr}" />
						</div>
					{/legend}
				{/jstab}

				{* any service edit template tabs *}
				{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_tab_tpl"}
			{/jstabs}
		{/form}
	</div><!-- end .body -->
</div><!-- end .{/literal}{$sample.class}{literal} -->

{/strip}{/literal}