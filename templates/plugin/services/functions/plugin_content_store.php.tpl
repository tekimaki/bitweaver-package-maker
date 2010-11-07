		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
		${{$config.name}}->setServiceContent( $pObject ); {{*@TODO maybe this and the instance declaration should go in *service_functions_inc.tpl *}} 
		if( !${{$config.name}}->storeTypemaps( $pParamHash, FALSE ) ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
		}
