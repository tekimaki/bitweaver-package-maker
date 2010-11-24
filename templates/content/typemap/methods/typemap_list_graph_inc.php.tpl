{{* generate a simple flat tail->head list from liberty_edge - not a true graph *}}
	function list{{$typemapName|ucfirst}}( $pParamHash = NULL ){
		$selectSql = $joinSql = $whereSql = "";
		$ret = $bindVars = array();

		$LC = new LibertyContent();
		$LC->getServicesSql( 'content_list_sql_function', $selectSql, $joinSql, $whereSql, $bindVars, NULL, $pParamHash );
		// vd( $selectSql ); vd( $joinSql ); vd( $whereSql ); vd( $bindVars );

		// limit results by head_content_id
		if( !empty( $pParamHash['{{$typemap.graph.head.field}}'] ) ){
			$bindVars[] = $pParamHash['{{$typemap.graph.head.field}}'];
			$whereSql .= " AND le.`head_content_id` = ?";
		}

		// limit results by tail_content_id
		if( !empty( $pParamHash['{{$typemap.graph.tail.field}}'] ) ){
			$bindVars[] = $pParamHash['{{$typemap.graph.tail.field}}'];
			$whereSql .= " AND le.`tail_content_id` = ?";
		}

		if( !empty( $whereSql ) ){
			$whereSql = preg_replace( '/^[\s]*AND\b/i', 'WHERE ', $whereSql );

			$query = "SELECT  le.`head_content_id`, le.`tail_content_id`, le.`weight` 
						FROM `liberty_edge` le 
{{* determine if head or tail references the pObject - default is tail *}}
{{if $typemap.graph.head.input.value.object }}
						INNER JOIN `liberty_content` lc ON lc.`content_id` = le.`head_content_id` 
{{else}}
						INNER JOIN `liberty_content` lc ON lc.`content_id` = le.`tail_content_id` 
{{/if}}
						$whereSql";

			$ret = $this->mDb->getArray( $query, $bindVars );
		}

		return $ret;
	}

	function getTailContentIds( $pParamHash = NULL ){
		$selectSql = $joinSql = $whereSql = "";
		$ret = $bindVars = array();

		$LC = new LibertyContent();
		$LC->getServicesSql( 'content_list_sql_function', $selectSql, $joinSql, $whereSql, $bindVars, NULL, $pParamHash );
		// vd( $selectSql ); vd( $joinSql ); vd( $whereSql ); vd( $bindVars );

		// limit results by head_content_id
		if( !empty( $pParamHash['{{$typemap.graph.head.field}}'] ) ){
			$bindVars[] = $pParamHash['{{$typemap.graph.head.field}}'];
			$whereSql .= " AND le.`head_content_id` = ?";
		}

		if( !empty( $whereSql ) ){
			$whereSql = preg_replace( '/^[\s]*AND\b/i', 'WHERE ', $whereSql );

			$query = "SELECT  le.`tail_content_id`, lc.`title` 
						FROM `liberty_edge` le 
						INNER JOIN `liberty_content` lc ON lc.`content_id` = le.`tail_content_id` 
						$whereSql";

			$ret = $this->mDb->getAssoc( $query, $bindVars );
		}

		return $ret;
	}

	function getHeadContentIds( $pParamHash = NULL ){
		$selectSql = $joinSql = $whereSql = "";
		$ret = $bindVars = array();

		$LC = new LibertyContent();
		$LC->getServicesSql( 'content_list_sql_function', $selectSql, $joinSql, $whereSql, $bindVars, NULL, $pParamHash );
		// vd( $selectSql ); vd( $joinSql ); vd( $whereSql ); vd( $bindVars );

		// limit results by tail_content_id
		if( !empty( $pParamHash['{{$typemap.graph.tail.field}}'] ) ){
			$bindVars[] = $pParamHash['{{$typemap.graph.tail.field}}'];
			$whereSql .= " AND le.`tail_content_id` = ?";
		}

		if( !empty( $whereSql ) ){
			$whereSql = preg_replace( '/^[\s]*AND\b/i', 'WHERE ', $whereSql );

			$query = "SELECT  le.`head_content_id`, lc.`title` 
						FROM `liberty_edge` le 
						INNER JOIN `liberty_content` lc ON lc.`content_id` = le.`head_content_id` 
						$whereSql";

			$ret = $this->mDb->getAssoc( $query, $bindVars );
		}

		return $ret;
	}
