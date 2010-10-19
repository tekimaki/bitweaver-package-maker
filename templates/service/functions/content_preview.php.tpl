		// call edit service which loads any data necessary for form
		${{$serviceName}} = new {{$service.class_name}}();
		$pObject->mInfo['{{$serviceName}}'] = ${{$serviceName}}->previewFields( $pParamHash );
