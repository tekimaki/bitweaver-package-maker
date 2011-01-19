	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $pIndex = NULL, $skipVerify = FALSE ){
{{if $type.base_package eq "liberty" || $typemap.base_table eq "liberty_content"}}
{{/if}}
		if( ( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash, $pIndex ) ) && !empty( $pParamHash['{{$type.name}}_store'] ) ){
			$table = '{{$type.name}}_{{$typemapName}}';
			$data = &$pParamHash['{{$type.name}}_store'];
{{foreach from=$typemap.attachments key=attachment item=prefs}}
			// Store the {{$attachment}} attachment
			if( empty( $data['{{$attachment}}_id'] ) && !empty( $_FILES['{{$typemapName}}_{{$attachment}}']['tmp_name'] ) ){
				$fileStoreHash['file'] = $_FILES['{{$typemapName}}_{{$attachment}}'];
				if( $this->mServiceContent->storeAttachment( $fileStoreHash ) ){
					// add the attachment id to our store hash
					$pParamHash['{{$type.name}}_store']['{{$attachment}}_id'] = $data['{{$attachment}}_id'] = $fileStoreHash['upload_store']['attachment_id'];
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
			$stored{{$typemapName|ucfirst}} = array();

			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){ 
			if( !$this->verify{{$typemapName|ucfirst}}Mixed( $pParamHash ) ){
					return FALSE;
				}

				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key=>&$data ){
					if( $this->store{{$typemapName|ucfirst}}( $data, $key, TRUE ) ){
						$stored{{$typemapName|ucfirst}}[] = $data['{{$type.name}}_store']['{{$typemapName}}_id'];
					}
					unset( $storeHash ); //f'n php
				}
			}else{
				$data = &$pParamHash['{{$type.name}}']['{{$typemapName}}'];
				if( $this->store{{$typemapName|ucfirst}}( $data, NULL, $skipVerify ) ){
					$stored{{$typemapName|ucfirst}}[] = $data['{{$type.name}}_store']['{{$typemapName}}_id'];
				}
			}

			// expunge records not submitted
			// get existing records
			$curr{{$typemapName|ucfirst}} = $this->list{{$typemapName|ucfirst}}( array( 'content_id' => $this->mServiceContent->mContentId) );
			// walk existing records
			foreach( $curr{{$typemapName|ucfirst}} as ${{$typemapName}}_id => $currData ){
				// if not in stored hash expunge
				if( !in_array( ${{$typemapName}}_id, $stored{{$typemapName|ucfirst}} ) ){
					// if the record has attachments store a reference
					$attachment_ids = array();
{{foreach from=$typemap.attachments key=attachment item=prefs}}
					if( !empty( $currData['{{$attachment}}_id'] ) ){
						$attachment_ids[] = $currData['{{$attachment}}_id'];
					}
{{/foreach}}
					// expunge the images
					$this->expunge{{$typemapName|ucfirst}}( $currData );
					foreach( $attachment_ids as $attachment_id ){
						// after expunge drop the attachments too
						$this->mServiceContent->expungeAttachment( $attachment_id );
					}
				}
			}

		}
		return count( $this->mErrors ) == 0;
	}

