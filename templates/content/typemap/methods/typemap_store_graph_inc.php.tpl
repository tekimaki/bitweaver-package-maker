	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $pIndex = NULL, $skipVerify = FALSE ){
		if( ( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash, $pIndex ) ) && !empty( $pParamHash['{{$type.name}}_store'] ) ) {
			// load a LibertyEdge instance
			require_once( LIBERTYGRAPH_PKG_PATH.'LibertyEdge.php' );
			$LE = new LibertyEdge( $pParamHash['{{$type.name}}_store']['tail_content_id'] );

        	// expunge first then we repopulate the record
			$expungeHash = $pParamHash['{{$type.name}}_store'];
        	$LE->expunge( $expungeHash );

			// store the liberty edge record
			$graphStoreHash['liberty_edge'] = $pParamHash['{{$type.name}}_store'];
			$LE->store( $graphStoreHash );
		}
        return count( $this->getErrors() == 0 );
	}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
		$this->mDb->StartTrans();

{{if $typemap.graph.head.input.value.object }}
		// drop associations and re-add them
		$query = "DELETE FROM `liberty_edge` le WHERE le.`head_content_id` = ? AND le.`tail_content_id` IN ( SELECT lc.content_id FROM `liberty_content` lc WHERE lc.`content_type_guid` = ? )";
		$bindVars[] = $this->mContentId;
{{foreach from=$typemap.graph.tail.input.type_limit item=ctype}}
		$bindVars[] = '{{$ctype}}';
{{/foreach}}
{{else}}
		// drop associations and re-add them
		$query = "DELETE FROM `liberty_edge` le WHERE le.`tail_content_id` = ? AND le.`head_content_id` IN ( SELECT lc.content_id FROM `liberty_content` lc WHERE lc.`content_type_guid` = ? )";
		$bindVars[] = $this->mContentId;
{{foreach from=$typemap.graph.head.input.type_limit item=ctype}}
		$bindVars[] = '{{$ctype}}';
{{/foreach}}
{{/if}}
		$this->mDb->query( $query, $bindVars );

		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key=>$data ){
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
