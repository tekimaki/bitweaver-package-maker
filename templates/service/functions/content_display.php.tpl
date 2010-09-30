        if( $pObject->isValid() ) {
            ${{$serviceName}} = new {{$service.class_name}}();
            $listHash = array( 'content_id' => $pObject->mContentId );
            $pObject->mInfo['{{$serviceName}}'] = ${{$serviceName}}->getList( $listHash );
        }
