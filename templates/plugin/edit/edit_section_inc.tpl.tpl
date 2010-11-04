<div class="body">
{formfeedback warning=$errors}
{form}
{legend legend="{{$section.title}}"}
	<input type="hidden" name="content_id" value="{$gContent->mContentId}" />
	<input type="hidden" name="content_type_guid" value="{$gContent->mContentTypeGuid}" />
	<input type="hidden" name="section" value="{$smarty.request.section}" />
	{include file="bitpackage:{{$config.package}}/{{$config.name}}/service_edit_mini_inc.tpl"}
	<div class="buttonHolder row submit">
		<input class="button" type="submit" name="store_{{$section.name}}" value="Save" />
	</div>
{/legend}
{/form}
</div>
