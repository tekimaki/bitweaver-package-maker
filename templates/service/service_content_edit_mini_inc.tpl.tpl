{strip}
{{* Are we rendering a plugin edit *}}
{{if !empty($config.plugin) }}
{if $gContent->hasService($smarty.const.LIBERTY_SERVICE_{{$config.name|strtoupper}})} 
{{foreach from=$config.typemaps key=typemapName item=typemap name=typemaps}}
{{if $typemap.services && in_array('content_edit_mini',$typemap.services)}}
	{if $gContent->isValid() && $gContent->hasUserPermission('p_{{$typemapName}}_service_update') ||
		$gContent->hasUserPermission('p_{{$typemapName}}_service_view')}
	{legend legend={{$typemap.label}}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id'}}
		<div class="row" id="row_{{$config.name}}_{{$fieldName}}" style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}">
{{include file="edit_field.tpl" namespace=`$config.name`[`$typemapName`]}}
		</div>
{{/if}}
{{/foreach}}
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
		{if $gContent->hasUserPermission('p_liberty_attach_attachments') }
			<div class="row {{$config.name}}_{{$attachment}}_id">
				{if !empty($gContent->mInfo.{{$attachment}}_id)}
					{assign var=attachment_id value=$gContent->mInfo.{{$attachment}}_id}
					{assign var=storage value=$gContent->mStorage.$attachment_id}
					{if !empty($storage)}
					{formlabel label="{{$prefs.name|ucfirst}}"}
					{forminput}
						{if $storage.is_mime}
							{include file=$gLibertySystem->getMimeTemplate('storage',$storage.attachment_plugin_guid) thumbsize=small preferences=$gContent->mStoragePrefs.$attachment_id attachment=$storage}
						{else}
							{jspopup href=$storage.source_url title=$storage.title|default:$storage.filename notra=1 img=$storage.thumbnail_url.avatar}
							<br />{$storage.filename} <span class="date">{$storage.file_size|display_bytes}</span>
							{if $smarty.foreach.atts.first}
								{formhelp note="click to see large preview"}
							{/if}
						{/if}
					{/forminput}
					{/if}
				{/if}

				{include file="bitpackage:liberty/edit_upload.tpl" upload_name="{{$typemapName}}_{{$attachment}}" upload_type="New {{$prefs.name|ucfirst}}"}
			</div>
		{/if}
{{/foreach}}
	{/legend}
	{/if}
{{/if}}
{{/foreach}}
{/if}
{{else}}
{{* We are editing a service *}}
{{assign var=serviceName value=$service.name}}
{if $gContent->hasService($smarty.const.LIBERTY_SERVICE_{{$serviceName|strtoupper}})} 
	{if $gContent->isValid() && $gContent->hasUserPermission('p_{{$serviceName}}_update') ||
		$gContent->hasUserPermission('p_{{$serviceName}}_view')}
	{legend legend=$serviceName.label|default:$serviceName}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
{{if $fieldName != 'content_id'}}
		<div class="row" id="row_{{$serviceName}}_{{$fieldName}}" style="{{foreach from=$field.input.styles.row key=param item=value}}{{$param}}:{{$value}};{{/foreach}}">
{{include file="edit_field.tpl" namespace=`$serviceName`_data }}
		</div>
{{/if}}
{{/foreach}}
        {/legend}
        {/if}
{/if}
{{/if}}
{/strip}
