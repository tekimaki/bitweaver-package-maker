       if( $pObject->isValid() ) {
            ${{$config.name}} = new {{$config.class_name}}();
            $listHash = array( 'content_id' => $pObject->mContentId );
            $pObject->mInfo['{{$config.name}}'] = ${{$config.name}}->getList( $listHash );
       } 
