		// call edit service which loads any data necessary for form
		{{$config.name}}_content_edit( $pObject, $pParamHash );
		// write form data on top of content hash
		${{$config.name}} = new {{$config.class_name}}(); 
		${{$config.name}}->setServiceContent( $pObject );
		${{$config.name}}->previewTypemaps( $pParamHash );
