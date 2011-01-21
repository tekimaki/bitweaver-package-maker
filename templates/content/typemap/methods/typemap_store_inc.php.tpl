	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( ( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) && !empty( $pParamHash['{{$type.name}}_store'] ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
			// record already exists, update it
			if( $this->get{{$typemapName|ucfirst}}ByContentId( $pParamHash['{{$type.name}}_store']['content_id'] ) ){
				$locId = array( 'content_id' => $pParamHash['{{$type.name}}_store']['content_id'] );
				unset( $pParamHash['{{$type.name}}_store']['content_id'] );
				$result = $this->mDb->associateUpdate( $table, $pParamHash['{{$type.name}}_store'], $locId );
			// create a new record
			}else{
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store'] );
			}
		}
		return count( $this->mErrors ) == 0;
	}

{{if $type.relation eq 'one-to-many' || $type.relation eq 'many-to-many'}}
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
{{/if}}
