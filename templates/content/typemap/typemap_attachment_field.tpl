{if $gContent->hasUserPermission('p_liberty_attach_attachments') }
	<div class="row {{$typemapName}}_{{$attachment}}">
		{if !empty($gContent->mInfo.{{$typemapName}}_{{$attachment}}_id)}
			{assign var={{$typemapName}}_{{$attachment}}_id value=$gContent->mInfo.{{$typemapName}}_{{$attachment}}_id}
			{assign var=storage value=$gContent->mStorage.${{$typemapName}}_{{$attachment}}_id}
			{if !empty($storage)}
			{formlabel label="{{$prefs.name|ucfirst}}"}
			{forminput}
				{if $storage.is_mime}
					{include file=$gLibertySystem->getMimeTemplate('storage',$storage.attachment_plugin_guid) thumbsize=small prelations=$gContent->mStoragePrefs.$attachmentId attachment=$storage}
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

		{formlabel label="{{$prefs.name|ucfirst}}" class="label"}
		{forminput}
			<input class="fileUpload" type="file" name="{{$typemapName}}_{{$attachment}}" size="40" />
			{{if $typemap.relation eq 'one-to-one'}}
				{formhelp note="Select a new {{$prefs.name|ucfirst}}."}
			{{/if}}
		{/forminput}
	</div>
	<div class="buttonHolder row">
		<input class="button" type="button" value="Upload" 
			onclick="javascript:LibertyPreflight.uploader( 
				this.form, 
				'{$smarty.const.LIBERTY_PKG_URL}preflight_uploader.php',
				'{tr}Please wait for the current upload to finish.{/tr}',
				'liberty_upload_frame_{{$config.name}}_{{$typemapName}}',
				'{{$config.name}}',
				'{{$typemapName}}'
			);" 
		/>
		{include file="bitpackage:liberty/preflight_uploader_inc.tpl" frame_id="{{$config.name}}_{{$typemapName}}" }
		<script type="text/javascript">
			LibertyPreflight.uploaderSetup( '{{$config.name}}_{{$typemapName}}' );
		</script>
	</div>
{/if}
