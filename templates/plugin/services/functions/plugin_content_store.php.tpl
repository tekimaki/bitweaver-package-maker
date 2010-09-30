        ${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
        if( !${{$config.name}}->storeTypemaps( $pParamHash, FALSE ) ){
            $pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
        }
