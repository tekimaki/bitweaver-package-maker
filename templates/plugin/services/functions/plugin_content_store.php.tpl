		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
		${{$config.name}}->setServiceContent( $pObject ); {{*@TODO maybe this and the instance declaration should go in *service_functions_inc.tpl *}} 
		if( !${{$config.name}}->storeTypemaps( $pParamHash, FALSE ) ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
		}
		else{
{{foreach from=$config.typemaps item=typemap key=typemapName}}
{{if $typemap.attachments}}
			// update the content hash when we have attachments because they use ajax upload
			$pObject->mInfo = array_merge( $pObject->mInfo, ${{$config.name}}->get{{$typemapName|ucfirst}}ByContentId( $pObject->mContentId ) ); 
{{/if}}
{{/foreach}}
		}
