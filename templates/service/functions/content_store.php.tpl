        ${{$serviceName}} = new {{$service.class_name}}( $pObject->mContentId );
        if( !${{$serviceName}}->store( $pParamHash ) ){
            $pObject->setError( '{{$serviceName}}', ${{$serviceName}}->mErrors );
        }
