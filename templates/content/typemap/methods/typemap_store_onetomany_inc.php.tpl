	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
{{if $typemap.base_table eq 'liberty_content'}}
		if( !isset( $pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] ) && $this->isValid() ){
			$pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] = $this->mContentId; 
		}
{{/if}}
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
			$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] );
		}
		return count( $this->mErrors ) == 0;
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 * uses bulk delete to avoid storage of duplicate records
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
//		require_once( UTIL_PKG_PATH.'phpcontrib_lib.php' );
		$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` WHERE `content_id` = ?";
		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
            if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['temp'] ) ){
                unset( $pParamHash['{{$type.name}}']['{{$typemapName}}']['temp'] ); 
            } 
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) /* && array_is_indexed( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) */){
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

