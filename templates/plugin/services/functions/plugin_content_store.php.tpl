		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
		${{$config.name}}->setServiceContent( $pObject ); {{*@TODO maybe this and the instance declaration should go in *service_functions_inc.tpl *}} 
		if( !${{$config.name}}->storeTypemaps( $pParamHash, FALSE ) ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
		}
		else{
{{foreach from=$config.typemaps item=typemap key=typemapName}}
{{if $typemap.attachments}}
			if( !empty( $pParamHash['{{$config.name}}']['{{$typemapName}}'] ) ){
				// update the content hash when we have attachments because they use ajax upload
{{if $typemap.relation eq 'one-to-many'}}
				$pObject->mInfo['{{$typemapName}}'] = ${{$config.name}}->list{{$typemapName|ucfirst}}(array( 'content_id' => $pObject->mContentId) ); 
{{elseif !$typemap.relation || $typemap.relation == 'one-to-one'}}
				$pObject->mInfo = array_merge( $pObject->mInfo, ${{$config.name}}->get{{$typemapName|ucfirst}}ByContentId( $pObject->mContentId ) );
{{/if}}
			}
{{/if}}
{{/foreach}}
		}
