	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $pIndex = NULL, $skipVerify = FALSE ){
{{if $typemap.base_table eq 'liberty_content'}}
{{/if}}
		if( ( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash, $pIndex ) ) && !empty( $pParamHash['{{$type.name}}_store'] ) ){
			$table = '{{$type.name}}_{{$typemapName}}';
			$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store'] );
		}
		return count( $this->mErrors ) == 0;
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 * uses bulk delete to avoid storage of duplicate records
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
		$this->mDb->StartTrans();

		// this is a nonsequenced table so clear existing before adding new
		$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` WHERE `content_id` = ?";
		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
            if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['temp'] ) ){
                unset( $pParamHash['{{$type.name}}']['{{$typemapName}}']['temp'] ); 
            } 
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key=>&$data ){
					$this->store{{$typemapName|ucfirst}}( $data, $key, $skipVerify );
				}
			}else{
				$data = &$pParamHash['{{$type.name}}']['{{$typemapName}}'];
				$this->store{{$typemapName|ucfirst}}( $data, NULL, $skipVerify );
			}
		}
		if( count( $this->mErrors ) > 0 ){
			// something failed undo delete and store
			$this->mDb->RollbackTrans();
		}
		$this->mDb->CompleteTrans();
		return count( $this->mErrors ) == 0;
	}

