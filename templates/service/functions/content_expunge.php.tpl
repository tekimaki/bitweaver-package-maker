		${{$serviceName}} = new {{$service.class_name}}( $pObject->mContentId );
		if( !${{$serviceName}}->expunge() ){
			$pObject->setError( '{{$serviceName}}', ${{$serviceName}}->mErrors );
		}
