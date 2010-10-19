		// expunge the {{$attachment}} attachment
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
{{foreach from=$typemap.attachments key=attachment item=prefs}}
		${{$config.name}}->expunge{{$attachment|ucfirst}}Attachment( $pObject, $pParamHash['attachment_id'] );
{{/foreach}}
