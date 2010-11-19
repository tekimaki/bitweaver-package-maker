{strip}
{{include file="smarty_file_header.tpl"}}

{* service template wrapper for displaying different sections defined by this plugin *}
{{foreach from=$config.sections key=sectionName item=section}}
{if $smarty.request.section eq '{{$sectionName}}'}
	{if $smarty.request.action eq 'edit'}
{{if $section.modes && in_array('edit',$section.modes)}}
	<div class="edit">
		<div class="header">
			<h1>{tr}Edit {{$sectionName|ucfirst}}{/tr}</h1>
		</div>
		<div class="body">
		{formfeedback warning=$errors}
		{form id="edit{{$sectionName}}form" enctype="multipart/form-data"}
			<input type="hidden" name="content_id" value="{$gContent->mContentId}" />
			<input type="hidden" name="content_type_guid" value="{$gContent->mContentTypeGuid}" />
			<input type="hidden" name="section" value="{$smarty.request.section}" />
			<div class="servicetabs">
{{if $section.typemaps.servicetab}}
{{foreach from=$section.typemaps.servicetab item=typemapName}} 
{{if $config.typemaps.$typemapName}}
				{include file="bitpackage:{{$config.package}}/{{$config.name}}/edit_{{$typemapName}}_inc.tpl" serviceHash=$gContent->mInfo formid="edit{{$sectionName}}form"}
{{/if}}
{{/foreach}}
{{/if}}
			</div>
			<div class="editcontainer">
{{* include typemaps listed *}}
{{if $section.typemaps.editcontainer}}
{{foreach from=$section.typemaps.editcontainer item=typemapName}} 
{{if $config.typemaps.$typemapName}}
				{include file="bitpackage:{{$config.package}}/{{$config.name}}/edit_{{$typemapName}}_inc.tpl" serviceHash=$gContent->mInfo formid="edit{{$sectionName}}form"}
{{/if}}
{{/foreach}}
{{* default include typemap with same name *}}
{{elseif $config.typemaps.$sectionName}}
				{include file="bitpackage:{{$config.package}}/{{$config.name}}/edit_{{$sectionName}}_inc.tpl" serviceHash=$gContent->mInfo formid="edit{{$sectionName}}form"}
{{/if}}
				<fieldset class="inlineLabels">
					<legend></legend>
					<div class="buttonHolder row submit">
						<input class="button" type="submit" name="store_{{$sectionName}}" value="Save" />
					</div>
				</fieldset>
			</div>
		{/form}
		</div>{* end .body *}
	</div>{* end .edit *}
{{/if}}
	{else}
{{if !$section.modes || in_array('view',$section.modes)}}
		{include file="bitpackage:{{$config.package}}/{{$config.name}}/display_{{$sectionName}}_inc.tpl" serviceHash=$gContent->mInfo formid="edit{{$sectionName}}form"}
{{/if}}
	{/if}
{/if}
{{/foreach}}
{/strip}
