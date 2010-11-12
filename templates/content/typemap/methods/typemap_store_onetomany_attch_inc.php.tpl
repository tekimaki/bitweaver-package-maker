	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
{{if $type.base_package eq "liberty" || $typemap.base_table eq "liberty_content"}}
		if( empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] ) && $this->isValid() ){
			$pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] = $this->mContentId; 
		}
{{/if}}
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
			$data = $pParamHash['{{$type.name}}_store']['{{$typemapName}}'];
{{foreach from=$typemap.attachments key=attachment item=prefs}}
			// Store the test_image attachment
			if( empty( $data['test_image_id'] ) && !empty( $_FILES['{{$typemapName}}_{{$attachment}}']['tmp_name'] ) ){
				$fileStoreHash['file'] = $_FILES['{{$typemapName}}_{{$attachment}}'];
				if( $this->mServiceContent->storeAttachment( $fileStoreHash ) ){
					// add the attachment id to our store hash
					$data['{{$attachment}}_id'] = $fileStoreHash['upload_store']['attachment_id'];
				}
			}
{{/foreach}}
			if({{foreach from=$typemap.attachments key=attachment item=prefs name=attch}} !empty( $data['{{$attachment}}_id'] ){{if !$smarty.foreach.attch.last}} &&{{/if}}{{/foreach}} ){
				// {{$typemapName}} id is set update the record
				if( !empty( $data['{{$typemapName}}_id'] ) ){
					$locId = array( '{{$typemapName}}_id' => $data['{{$typemapName}}_id'] );
					// unset( $data['{{$typemapName}}_id'] );
					$result = $this->mDb->associateUpdate( $table, $data, $locId );
				// {{$typemapName}} id is not set create a new record
				}else{
					$data['{{$typemapName}}_id'] = $this->mDb->GenID('{{$type.name}}_{{$typemapName}}_id_seq');
					$result = $this->mDb->associateInsert( $table, $data );
				}
			}
			unset( $data ); // f'n php
		}
		return count( $this->mErrors ) == 0;
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){ 
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $data ){
					$storeHash['{{$type.name}}']['{{$typemapName}}'] = $data;
					$this->store{{$typemapName|ucfirst}}( $storeHash, $skipVerify );
					unset( $storeHash ); //f'n php
				}
			}else{
				$this->store{{$typemapName|ucfirst}}( $pParamHash, $skipVerify );
			}
		}
		return count( $this->mErrors ) == 0;
	}

