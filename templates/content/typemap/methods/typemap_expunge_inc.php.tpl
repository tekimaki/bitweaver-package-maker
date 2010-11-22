	function expunge{{$typemapName|ucfirst}}( &$pParamHash ){
		$ret = FALSE;
		$bindVars = array();
		$whereSql = "";

{{if $typemap.sequence}}
		// limit results by {{$typemapName}}_id
		if( !empty( $pParamHash['{{$typemapName}}_id'] ) ){
			$bindVars[] = $pParamHash['{{$typemapName}}_id'];
			$whereSql .= " AND `{{$typemapName}}_id` = ?";
		}

{{/if}}

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql .= " AND `content_id` = ?";
		}

		if ( !empty($whereSql) ) {
			$whereSql = preg_replace( '/^[\s]*AND\b/i', 'WHERE ', $whereSql );
			$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` ".$whereSql;
			$this->mDb->query( $query, $bindVars );

			if( $this->mDb->query( $query, $bindVars ) ){
				$ret = TRUE;
			}
		}

		return $ret;
	}

