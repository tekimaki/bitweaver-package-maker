{if $gContent->hasUserPermission('p_liberty_attach_attachments') }
	<div class="row {{$typemapName}}_{{$attachment}}">
		{formlabel label="{{$prefs.name|ucfirst}}" class="label"}
		{{if $typemap.relation eq 'one-to-one'}}
		{if $gContent->mInfo.{{$attachment}}_id}
			{assign var=attachment_id value=$gContent->mInfo.{{$attachment}}_id}
			{assign var=storage value=$gContent->mStorage.$attachment_id}
			{if $storage}
			{forminput}
				{include file=$gLibertySystem->getMimeTemplate('storage',$storage.attachment_plugin_guid) thumbsize=small prelations=$gContent->mStoragePrefs.$attachment_id attachment=$storage}
			{/forminput}
			{/if}
		{/if}
		{{/if}}

		{forminput}
			<input class="fileUpload" type="file" name="{{$typemapName}}_{{$attachment}}" size="{{$prefs.input.size|default:40}}" />
			{{if $typemap.relation eq 'one-to-one'}}
				{formhelp note="Select a new {{$prefs.name|ucfirst}}."}
			{{/if}}
		{/forminput}
	</div>
{{if !isset($prefs.input.preflight) || $prefs.input.preflight}}
	<div class="buttonHolder row">
		<input class="button add" type="button" value="Upload" name="store_{{$typemapName}}" 
			onclick="LibertyPreflight.uploader( 
				this.form, 
				'{$smarty.const.LIBERTY_PKG_URL}preflight_uploader.php',
				'{tr}Please wait for the current upload to finish.{/tr}',
				'liberty_upload_frame_{{$config.name}}_{{$typemapName}}',
				'{{$config.name}}',
				'{{$typemapName}}'
			);" 
		/>
		{include file="bitpackage:liberty/preflight_uploader_inc.tpl" frame_id="{{$config.name}}_{{$typemapName}}" }
	</div>
{{/if}}
{/if}
