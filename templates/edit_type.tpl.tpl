{literal}{strip}
<div class="floaticon">{bithelp}</div>

<div class="admin {/literal}{$package}{literal}">
	{if $smarty.request.preview}
		<h2>Preview {$gContent->mInfo.title|escape}</h2>
		<div class="preview">
			{include file="bitpackage:{/literal}{$package}{literal}/display_{/literal}{$package}{literal}.tpl" page=`$gContent->mInfo.{/literal}{$package}{literal}_id`}
		</div>
	{/if}

	<div class="header">
		<h1>
			{if $gContent->mInfo.{/literal}{$package}{literal}_id}
				{tr}Edit {$gContent->mInfo.title|escape}{/tr}
			{else}
				{tr}Create New Record{/tr}
			{/if}
		</h1>
	</div>

	<div class="body">
		{form enctype="multipart/form-data" id="edit{/literal}{$package}{literal}form"}
			{jstabs}
				{jstab title="Record"}
					{legend legend="{/literal}{$Package}{literal} Record"}
						<input type="hidden" name="{/literal}{$package}{literal}[{/literal}{$package}{literal}_id]" value="{$gContent->mInfo.{/literal}{$package}{literal}_id}" />
						{formfeedback warning=$errors.store}

						<div class="row">
							{formfeedback warning=$errors.title}
							{formlabel label="Title" for="title"}
							{forminput}
								<input type="text" size="50" name="{/literal}{$package}{literal}[title]" id="title" value="{$gContent->mInfo.title|escape}" />
							{/forminput}
						</div>

						<div class="row">
							{formlabel label="Description" for="description"}
							{forminput}
								<input type="text" size="50" maxlength="160" name="{/literal}{$package}{literal}[description]" id="description" value="{$gContent->mInfo.description|escape}" />
								{formhelp note="Brief description of the page."}
							{/forminput}
						</div>

						{textarea name="{/literal}{$package}{literal}[edit]"}{$gContent->mInfo.data}{/textarea}

						{* any simple service edit options *}
						{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_mini_tpl"}

						<div class="row submit">
							<input type="submit" name="preview" value="{tr}Preview{/tr}" />
							<input type="submit" name="save_{/literal}{$package}{literal}" value="{tr}Save{/tr}" />
						</div>
					{/legend}
				{/jstab}

				{* any service edit template tabs *}
				{include file="bitpackage:liberty/edit_services_inc.tpl" serviceFile="content_edit_tab_tpl"}
			{/jstabs}
		{/form}
	</div><!-- end .body -->
</div><!-- end .{/literal}{$package}{literal} -->

{/strip}{/literal}