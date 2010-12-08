	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
{{* determine if head or tail references the pObject - default is tail *}}
{{if $typemap.graph.head.input.value.object }}
		if( empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] ) && $this->isValid() ){
			$pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] = $this->mContentId; 
		}
{{else}}
		if( empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] ) && $this->isValid() ){
			$pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] = $this->mContentId; 
		}
{{/if}}

		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] ) && 
			!empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] ) 
		){
			// load a LibertyEdge instance
			require_once( LIBERTYGRAPH_PKG_PATH.'LibertyEdge.php' );
			$LE = new LibertyEdge( $graphStoreHash['liberty_edge']['tail_content_id'] );

        	// expunge first then we repopulate the record
			$expungeHash = array( 'head_content_id' => $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'], 
								  'tail_content_id' => $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] 
								);
			// expunge the liberty edge record
        	$LE->expunge( $expungeHash );

			// must have a tail content id 
			$graphStoreHash['liberty_edge']['tail_content_id'] = $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'];
			// must have a head content id to store
			$graphStoreHash['liberty_edge']['head_content_id'] = $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'];

			// store the liberty edge record
			$LE->store( $graphStoreHash );
		}
        return count( $this->getErrors() == 0 );
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
//		require_once( UTIL_PKG_PATH.'phpcontrib_lib.php' );

{{if $typemap.graph.head.input.value.object }}
		// drop associations and re-add them
		$query = "DELETE FROM `liberty_edge` le WHERE le.`head_content_id` = ? AND le.`tail_content_id` IN ( SELECT lc.content_id FROM `liberty_content` lc WHERE lc.`content_type_guid` = ? )";
		$bindVars[] = $this->mContentId;
{{foreach from=$typemap.graph.tail.input.type_limit item=ctype}}
		$bindVars[] = '{{$ctype}}';
{{/foreach}}
		$this->mDb->query( $query, $bindVars );

		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] ) /* && array_is_indexed( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] ) */){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] as $data ){
					$storeHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] = $data;
					$this->store{{$typemapName|ucfirst}}( $storeHash, $skipVerify );
				}
			}else{
				$this->store{{$typemapName|ucfirst}}( $pParamHash, $skipVerify );
			}
		}
{{else}}
		// drop associations and re-add them
		$query = "DELETE FROM `liberty_edge` le WHERE le.`tail_content_id` = ? AND le.`head_content_id` IN ( SELECT lc.content_id FROM `liberty_content` lc WHERE lc.`content_type_guid` = ? )";
		$bindVars[] = $this->mContentId;
{{foreach from=$typemap.graph.head.input.type_limit item=ctype}}
		$bindVars[] = '{{$ctype}}';
{{/foreach}}
		$this->mDb->query( $query, $bindVars );

		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] ) /* && array_is_indexed( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] ) */){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] as $data ){
					$storeHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'] = $data;
					$this->store{{$typemapName|ucfirst}}( $storeHash, $skipVerify );
				}
			}else{
				$this->store{{$typemapName|ucfirst}}( $pParamHash, $skipVerify );
			}
		}
{{/if}}
		return count( $this->mErrors ) == 0;
	}
