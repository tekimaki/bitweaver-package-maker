// {{literal}}{{{{{/literal}} =================== TypeMap Fieldset {{$typemapName|ucfirst}} Handlers  ====================


{{* @TODO This only really works if the table has a sequnenced column, need some other way of getting a unique value if desired *}}
{{if $typemap.sequence}}
	/**
	 * load a row from the {{$type.name}}_{{$typemapName}} table 
	 */
	 function load{{$typemapName|ucfirst}}( $p{{$typemapName|ucfirst}}Id = NULL ){
		$ret = array();
		if( $this->verifyId( $p{{$typemapName|ucfirst}}Id ) ){
			$query = "SELECT `{{$typemapName}}_id` as hash_key, `{{$typemapName}}_id`,{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$type.name}}_{{$typemapName}}` WHERE `{{$type.name}}_{{$typemapName}}`.{{$typemapName}}_id = ?";
			$ret = $this->mDb->getAssoc( $query, $bindVars );
		}
		return $ret;
	}

	/**
	 * stores one or more records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
			if( !empty( $pParamHash['{{$typemapName}}_store'] )){
				foreach ($pParamHash['{{$typemapName}}_store'] as $key => &$data) {
{{if $type.base_package == "liberty"}}
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
{{else}}
	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( &$pParamHash ) ) {
			if ( !empty( $pParamHash['{{$typemapName}}_store'] )){
				$table = '{{$type.name}}_{{$typemapName}}';
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$typemapName}}_store'] );
			}
		}
	}
{{/if}}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
{{if !$typemap.sequence}}	 * uses bulk delete to avoid storage of duplicate records{{/if}} 
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
{{if !$typemap.sequence && $typemap.relation != 'one-to-one'}}
		$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` WHERE `content_id` = ?";
		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
{{/if}} 
		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $data ){
					$storeHash['{{$type.name}}']['{{$typemapName}}'] = $data;
					$this->store{{$typemapName|ucfirst}}( $storeHash, $skipVerify );
				}
			}else{
				$this->store{{$typemapName|ucfirst}}( $pParamHash, $skipVerify );
			}
		}
	}

	/** 
	 * verifies a data set for storage in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 * data is put into $pParamHash['{{$typemapName}}_store'] for storage
	 */
	function verify{{$typemapName|ucfirst}}( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
		$this->validate{{$typemapName|ucfirst}}Fields($pParamHash);
		return( count( $this->mErrors )== 0 );
	}

	function expunge{{$typemapName|ucfirst}}( &$pParamHash ){
		$ret = FALSE;
		$bindVars = array();
		$whereSql = "";

{{if $typemap.sequence}}
		// limit results by {{$typemapName}}_id
		if( !empty( $pParamHash['{{$typemapName}}_id'] ) ){
			$bindVars[] = $pParamHash['{{$typemapName}}_id'];
			$whereSql .= "`{{$typemapName}}_id` = ?";
		}

{{/if}}

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql .= "`content_id` = ?";
		}

		$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` WHERE ".$whereSql;
		$this->mDb->query( $query, $bindVars );

		if( $this->mDb->query( $query, $bindVars ) ){
			$ret = TRUE;
		}

		return $ret;
	}

	function list{{$typemapName|ucfirst}}( $pParamHash = NULL ){
		$ret = $bindVars = array();

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql = " WHERE `{{$type.name}}_{{$typemapName}}`.content_id = ?";
		} elseif( $this->isValid() ){
			$bindVars[] = $this->mContentId;
			$whereSql = " WHERE `{{$type.name}}_{{$typemapName}}`.content_id = ?";
		}

		$query = "SELECT {{if $typemap.sequence}}`{{$typemapName}}_id` as hash_key, `{{$typemapName}}_id`,{{/if}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$type.name}}_{{$typemapName}}`".$whereSql;
{{if $typemap.sequence}}
		$ret = $this->mDb->getAssoc( $query, $bindVars );
{{else}}
		$ret = $this->mDb->getArray( $query, $bindVars );
{{/if}}
		return $ret;
	}

	/**
	 * preview{{$typemapName|ucfirst}}Fields prepares the fields in this type for preview
	 */
	 function preview{{$typemapName|ucfirst}}Fields(&$pParamHash) {
		$this->prep{{$typemapName|ucfirst}}Verify();
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			foreach($pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key => $data) {
				LibertyValidator::preview(
					$this->mVerification['{{$type.name}}_{{$typemapName}}'],
					$pParamHash['{{$type.name}}']['{{$typemapName}}'][$key],
					$this, $pParamHash['{{$typemapName}}_store'][$key]);
			}
		}
	}

	/**
	 * validate{{$typemapName|ucfirst}}Fields validates the fields in this type
	 */
	function validate{{$typemapName|ucfirst}}Fields(&$pParamHash) {
		$this->prep{{$typemapName|ucfirst}}Verify();
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			foreach($pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key => &$data) {
				LibertyValidator::validate(
					$this->mVerification['{{$type.name}}_{{$typemapName}}'],
					$pParamHash['{{$type.name}}']['{{$typemapName}}'][$key],
					$this, $pParamHash['{{$typemapName}}_store'][$key]);
			}
		}
	}

	/**
	 * prep{{$typemapName|ucfirst}}Verify prepares the object for input verification
	 */
	function prep{{$typemapName|ucfirst}}Verify() {
		if (empty($this->mVerification['{{$type.name}}_{{$typemapName}}'])) {

{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
	 		/* Validation for {{$fieldName}} */
{{if !empty($field.validator.type) && $field.validator.type != "no-input"}}
			$this->mVerification['{{$type.name}}_{{$typemapName}}']['{{$field.validator.type}}']['{{$fieldName}}'] = array(
				'name' => '{{$fieldName}}',
{{foreach from=$field.validator key=k item=v name=keys}}
{{if $k != 'type'}}
				'{{$k}}' => {{if is_array($v)}}array(
{{foreach from=$v key=vk item=vv name=values}}
					{{if is_numeric($vk)}}{{$vk}}{{else}}'{{$vk}}'{{/if}} => '{{$vv}}'{{if !$smarty.foreach.values.last}},{{/if}}

{{/foreach}}
					){{else}}'{{$v}}'{{/if}}{{if !$smarty.foreach.keys.last}},{{/if}}

{{/if}}
{{/foreach}}
			);
{{elseif empty($field.validator.type)}}
			$this->mVerification['{{$type.name}}_{{$typemapName}}']['null']['{{$fieldName}}'] = TRUE;
{{/if}}
{{/foreach}}

		}
	}

	// {{literal}}}}}{{/literal}}
