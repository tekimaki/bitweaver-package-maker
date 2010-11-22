	function expunge{{$typemapName|ucfirst}}( &$pParamHash ){
		$ret = FALSE;
		$expungeHash = $bindVars = array();
		$whereSql = "";

		// limit results by head_content_id
		if( !empty( $pParamHash['expunge_{$typemap.graph.head.field}}'] ) ){
			$expungeHash['head_content_id'] = $pParamHash['expunge_{{$typemap.graph.head.field}}'];
		}

		// limit results by tail_content_id
		if( !empty( $pParamHash['expunge_{{$typemap.graph.tail.field}}'] ) ){
			$expungeHash['tail_content_id'] = $pParamHash['expunge_{{$typemap.graph.tail.field}}'];
		}

		if( !empty( $expungeHash ) ){
			$LE = new LibertyEdge();
			$ret = $LE->expunge( $expungeHash );
		}

		return $ret;
	}

