		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
		${{$config.name}}->setServiceContent( $pObject ); {{*@TODO maybe this and the instance declaration should go in *service_functions_inc.tpl *}} 
		if( !${{$config.name}}->verifyTypemaps( $pParamHash ) ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
			// if store fails make sure we've got the base data loaded - preview will modify 
{{foreach from=$config.typemaps item=typemap key=typemapName}}
{{if $typemap.relation eq 'one-to-many'}}
			$pObject->mInfo['{{$typemapName}}'] = ${{$config.name}}->list{{$typemapName|ucfirst}}(array( 'content_id' => $pObject->mContentId) ); 
{{elseif !$typemap.relation || $typemap.relation == 'one-to-one'}}
			if( $data = ${{$config.name}}->get{{$typemapName|ucfirst}}ByContentId( $pObject->mContentId ) ){
				$pObject->mInfo = array_merge( $pObject->mInfo, $data );
			}
{{/if}}
{{/foreach}}
			{{$config.name}}_content_preview( $pObject, $pParamHash );
		}
		else{
			if( empty( $pParamHash['preflight_fieldset_guid'] ) ){
				// store all
				${{$config.name}}->storeTypemaps( $pParamHash );
			}else{
				// store specific typemap via ajax request
				switch( $pParamHash['preflight_fieldset_guid'] ){
{{foreach from=$config.typemaps item=typemap key=typemapName}}
				case '{{$typemapName}}':
{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}
					${{$config.name}}->store{{$typemapName|ucfirst}}Mixed($pParamHash, TRUE);
{{else}}
					${{$config.name}}->store{{$typemapName|ucfirst}}($pParamHash, TRUE);
{{/if}}
					break;
{{/foreach}}
				}
			}
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
