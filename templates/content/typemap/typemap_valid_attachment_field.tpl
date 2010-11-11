{{* This template is for one to many lists *}} 
{if $gContent->hasUserPermission('p_liberty_attach_attachments') }
	{assign var=attachment_id value=${{$typemapName}}.{{$attachment}}_id}
	{if $gContent->mStorage.$attachment_id}
		{assign var=storage value=$gContent->mStorage.$attachment_id}
		<div class="row {{$config.name}}_{{$attachment}}_id">
			{formlabel label="{{$prefs.name|ucfirst}}"}
			{forminput}
				{include file=$gLibertySystem->getMimeTemplate('storage',$storage.attachment_plugin_guid) thumbsize=small prelations=$gContent->mStoragePrefs.$attachment_id attachment=$storage}
			{/forminput}
			{{assign var=namespace value="`$config.name`[`$typemapName`]["|cat:'{$index}]'}}
			<input type="hidden" name="{{$namespace}}[{{$attachment}}]" value="{$gContent->mStorage.$attachment_id}" />
		</div>
	{/if}
{/if}
