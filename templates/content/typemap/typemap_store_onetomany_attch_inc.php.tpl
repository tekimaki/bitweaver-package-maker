	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
{{if $typemap.base_table eq 'liberty_content'}}
		if( empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] ) && $this->isValid() ){
			$pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] = $this->mContentId; 
		}
{{/if}}
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
{{foreach from=$typemap.attachments key=attachment item=prefs}}
			$old_{{$attachment}}_id = array();

			// Store the test_image attachment
			if( !empty( $_FILES['{{$typemapName}}_{{$attachment}}']['tmp_name'] ) ){
				$fileStoreHash['file'] = $_FILES['{{$typemapName}}_{{$attachment}}'];
				if( $this->mServiceContent->storeAttachment( $fileStoreHash ) ){
					// add the attachment id to our store hash
					$pParamHash['{{$type.name}}_store']['{{$typemapName}}']['{{$attachment}}_id'] = $fileStoreHash['upload_store']['attachment_id'];
				}
			}
{{/foreach}}
{{* @TODO update is required of attachments - they must be sequenced tables 
			// record already exists, update it
			if( $this->get{{$typemapName|ucfirst}}ByContentId( $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] ) ){
				$locId = array( 'content_id' => $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] );
				unset( $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] );
				$result = $this->mDb->associateUpdate( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'], $locId );
			// create a new record
			}else{
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] );
			}
*}}
			$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] );
		}
		return count( $this->mErrors ) == 0;
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
		require_once( UTIL_PKG_PATH.'phpcontrib_lib.php' );
		$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` WHERE `content_id` = ?";
		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) && array_is_indexed( $pParamHash['{{$type.name}}']['{{$typemapName}}'] )){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $data ){
					$storeHash['{{$type.name}}']['{{$typemapName}}'] = $data;
					$this->store{{$typemapName|ucfirst}}( $storeHash, $skipVerify );
				}
			}else{
				$this->store{{$typemapName|ucfirst}}( $pParamHash, $skipVerify );
			}
		}
		return count( $this->mErrors ) == 0;
	}

