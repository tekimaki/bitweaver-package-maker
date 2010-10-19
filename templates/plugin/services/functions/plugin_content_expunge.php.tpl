		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
		if( !${{$config.name}}->expungeTypemaps() ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
		}
