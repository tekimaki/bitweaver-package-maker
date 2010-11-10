{{* This tpl currently renders a store function for 
	sequenced tables that are for both one-to-one and one-to-many records 
	Split this file as soon as such a conditional is required
*}}
	/**
	 * stores one or more records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
			if( !empty( $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] )){
				foreach ($pParamHash['{{$type.name}}_store']['{{$typemapName}}'] as $key => &$data) {
{{if $type.base_package == "liberty" || $type.base_table == "liberty_content"}}
					if (!empty($pParamHash['{{$type.name}}']['content_id'])) {
						$data['content_id'] = $pParamHash['{{$type.name}}']['content_id'];
					} else {
						$data['content_id'] = $this->mContentId;
					}
{{/if}}
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
			}
		}
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
		require_once( UTIL_PKG_PATH.'phpcontrib_lib.php' );
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

