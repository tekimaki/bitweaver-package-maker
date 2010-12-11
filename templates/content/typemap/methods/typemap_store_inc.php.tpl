	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] ) && $this->isValid() ){
			$pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] = $this->mContentId; 
		}
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
			// record already exists, update it
			if( $this->get{{$typemapName|ucfirst}}ByContentId( $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] ) ){
				$locId = array( 'content_id' => $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] );
				unset( $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] );
				$result = $this->mDb->associateUpdate( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'], $locId );
			// create a new record
			}else{
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] );
			}
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
