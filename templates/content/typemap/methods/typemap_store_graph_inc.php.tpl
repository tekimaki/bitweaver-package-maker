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
        	// expunge first then we repopulate the record
			$expungeHash = array( 'expunge_{{$typemap.graph.head.field}}' => $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'], 
									'expunge_{{$typemap.graph.tail.field}}' => $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'] 
								);
        	$this->expunge( $expungeHash );

			// must have a tail content id 
			$graphStoreHash['liberty_edge']['tail_content_id'] = $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.tail.field}}'];
			// must have a head content id to store
			$graphStoreHash['liberty_edge']['head_content_id'] = $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemap.graph.head.field}}'];

			require_once( LIBERTYGRAPH_PKG_PATH.'LibertyEdge.php' );
			$LE = new LibertyEdge( $graphStoreHash['liberty_edge']['tail_content_id'] );
			$LE->store( $graphStoreHash );
		}
        return count( $this->getErrors() == 0 );
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
