<div class="body">
{formfeedback warning=$errors}
{form}
{legend legend="{{$section.title}}"}
	<input type="hidden" name="content_id" value="{$gContent->mContentId}" />
	<input type="hidden" name="content_type_guid" value="{$gContent->mContentTypeGuid}" />
	<input type="hidden" name="section" value="{$smarty.request.section}" />
	{{* TODO this is a hack which expects a matching typemap name 
		change this to process a list of typemaps specified 
		or default to a match if it exists (so check that it exists
	*}}
	{include file="bitpackage:{{$config.package}}/{{$config.name}}/fieldset_{{$section.name}}_inc.tpl"}
	<div class="buttonHolder row submit">
		<input class="button" type="submit" name="store_{{$section.name}}" value="Save" />
	</div>
{/legend}
{/form}
</div>
