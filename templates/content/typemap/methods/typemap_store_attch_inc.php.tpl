	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( ( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) && !empty( $pParamHash['{{$type.name}}_store'] ) ){
			$table = '{{$type.name}}_{{$typemapName}}';
{{if $typemap.base_table eq 'liberty_content'}}
{{foreach from=$typemap.attachments key=attachment item=prefs}}
			$old_{{$attachment}}_id = array();

			// Store the {{$attachment}} attachment
			if( !empty( $_FILES['{{$typemapName}}_{{$attachment}}']['tmp_name'] ) ){
				$fileStoreHash['file'] = $_FILES['{{$typemapName}}_{{$attachment}}'];
				if( $this->mServiceContent->storeAttachment( $fileStoreHash ) ){
					// add the attachment id to our store hash
					$pParamHash['{{$type.name}}_store']['{{$attachment}}_id'] = $fileStoreHash['upload_store']['attachment_id'];
					// For one to one we need to expunge an old attachment_id
					// Figure out if we have one at all and if it has an old value
					$old_{{$attachment}}_id = $this->mDb->getAssoc("SELECT `content_id`, `{{$attachment}}_id` FROM `{{$type.name}}_{{$typemapName}}` WHERE `content_id` = ?", array('content_id' => $pParamHash['content_id']));
				}
			}
{{/foreach}}

			// record already exists, update it
			if( $this->get{{$typemapName|ucfirst}}ByContentId( $pParamHash['{{$type.name}}_store']['content_id'] ) ){
				$locId = array( 'content_id' => $pParamHash['{{$type.name}}_store']['content_id'] );
				unset( $pParamHash['{{$type.name}}_store']['content_id'] );
				$result = $this->mDb->associateUpdate( $table, $pParamHash['{{$type.name}}_store'], $locId );
			// create a new record
			}else{
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store'] );
			}

{{foreach from=$typemap.attachments key=attachment item=prefs}}
			// For one to one we need to expunge old {{$attachment}} attachment_id
			if( !empty( $old_{{$attachment}}_id[$pParamHash['content_id']] ) ) {
				$attachment_id = $old_{{$attachment}}_id[$pParamHash['content_id']];
				$this->mServiceContent->expungeAttachment( $attachment_id );
			}
{{/foreach}}
{{/if}}
		}
		return count( $this->mErrors ) == 0;
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
		require_once( UTIL_PKG_PATH.'phpcontrib_lib.php' );
		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) && array_is_indexed( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as &$data ){
					$this->store{{$typemapName|ucfirst}}( $data, $skipVerify );
				}
			}else{
				$data = &$pParamHash['{{$type.name}}']['{{$typemapName}}'];
				$this->store{{$typemapName|ucfirst}}( $data, $skipVerify );
			}
		}
		return count( $this->mErrors ) == 0;
	}

