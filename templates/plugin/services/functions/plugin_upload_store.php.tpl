{{if !empty($typemap.attachments)}}
{{foreach from=$typemap.attachments key=attachment item=prefs}}
		// Store the {{$attachment}} attachment
		if ( !empty($pParamHash['upload_store']['files']['{{$typemapName}}_{{$attachment}}']) ) {
			${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
			${{$config.name}}->store{{$attachment|ucfirst}}Attachment($pObject, $pParamHash['upload_store']['files']['{{$typemapName}}_{{$attachment}}']);
		}
{{/foreach}}
{{/if}}
