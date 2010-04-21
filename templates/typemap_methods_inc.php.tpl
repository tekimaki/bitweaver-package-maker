{literal}
	// {{{ =================== {/literal}{$typemapName|ucfirst}{literal} Handlers  ====================

{/literal}
{* @TODO This only really works if the table has a sequnenced column, need some other way of getting a unique value if desired *}
{if $typemap.sequence}{literal}
	/**
	 * load a row from the {/literal}{$type.name}_{$typemapName}{literal} table 
	 */
	 function load{/literal}{$typemapName|ucfirst}{literal}( $p{/literal}{$typemapName|ucfirst}{literal}Id = NULL ){
		$ret = array();
		if( $this->verifyId( $p{/literal}{$typemapName|ucfirst}{literal}Id ) ){
			$query = "{/literal}SELECT `{$typemapName}_id`,{foreach from=$typemap.fields key=fieldName item=field name=fields}
 `{$fieldName}`{if !$smarty.foreach.fields.last},{/if}
{/foreach}
 FROM `{$type.name}_{$typemapName}` WHERE `{$type.name}_{$typemapName}`.{$typemapName}_id = ?{literal}";
			$ret = $this->mDb->getArray( $query, $bindVars );
		}
		return $ret;
	}

	/**
	 * stores one or more records in the {/literal}{$type.name}_{$typemapName}{literal} table
	 */
	function store{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{/literal}{$typemapName|ucfirst}{literal}( $pParamHash ) ) {
			$table = '{/literal}{$type.name}_{$typemapName}{literal}';
			if( !empty( $pParamHash['{/literal}{$typemapName}{literal}_store'] )){
				foreach ($pParamHash['{/literal}{$typemapName}{literal}_store'] as $key => &$data) {
{/literal}{if $type.base_package == "liberty"}{literal}
					if (!empty($pParamHash['{/literal}{$type.name}{literal}']['content_id'])) {
						$data['content_id'] = $pParamHash['{/literal}{$type.name}{literal}']['content_id'];
					} else {
						$data['content_id'] = $this->mContentId;
					}
{/literal}{/if}{literal}
					// {/literal}{$typemapName}{literal} id is set update the record
					if( !empty( $data['{/literal}{$typemapName}{literal}_id'] ) ){
						$locId = array( '{/literal}{$typemapName}{literal}_id' => $data['{/literal}{$typemapName}{literal}_id'] );
						// unset( $data['{/literal}{$typemapName}{literal}_id'] );
						$result = $this->mDb->associateUpdate( $table, $data, $locId );
					// {/literal}{$typemapName}{literal} id is not set create a new record
					}else{
						$data['{/literal}{$typemapName}{literal}_id'] = $this->mDb->GenID('{/literal}{$type.name}_{$typemapName}{literal}_id_seq');
						$result = $this->mDb->associateInsert( $table, $data );
					}
				}
			}
		}
	}
{/literal}{else}{literal}
	/**
	 * stores a single record in the {/literal}{$type.name}_{$typemapName|ucfirst}{literal} table
	 */
	function store{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ) ) {
			if ( !empty( $pParamHash['{/literal}{$typemapName}{literal}_store'] )){
				$table = '{/literal}{$type.name}_{$typemapName}{literal}';
				$result = $this->mDb->associateInsert( $table, $pParamHash['{/literal}{$typemapName}{literal}_store'] );
			}
		}
	}
{/literal}{/if}{literal}

	/**
	 * stores multiple records in the {/literal}{$type.name}_{$typemapName}{literal} table
{/literal}{if !$typemap.sequence}	 * uses bulk delete to avoid trying to store duplicate records{/if}{literal} 
	 */
	function store{/literal}{$typemapName|ucfirst}{literal}Mixed( &$pParamHash, $skipVerify = FALSE ){
{/literal}
		$query = "DELETE FROM `{$type.name}_{$typemapName}` WHERE `content_id` = ?";
{literal}
		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
		$this->store{/literal}{$typemapName|ucfirst}{literal}( $pParamHash, $skipVerify );
	}

	/** 
	 * verifies a data set for storage in the {$type.name}_{$typemapName|ucfirst} table
	 * data is put into $pParamHash['{/literal}{$typemapName}{literal}_store'] for storage
	 */
	function verify{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
		$this->validate{/literal}{$typemapName|ucfirst}{literal}Fields($pParamHash);
		return( count( $this->mErrors )== 0 );
	}

	function expunge{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ){
		$ret = FALSE;
		$bindVars = array();
		$whereSql = "";

{/literal}{if $typemap.sequence}{literal}
		// limit results by {/literal}{$typemapName}{literal}_id
		if( !empty( $pParamHash['{/literal}{$typemapName}{literal}_id'] ) ){
			$bindVars[] = $pParamHash['{/literal}{$typemapName}{literal}_id'];
			$whereSql .= "`{/literal}{$typemapName}{literal}_id` = ?";
		}
{/literal}
{/if}
{literal}
		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql .= "`content_id` = ?";
		}

		$query = "DELETE FROM `{/literal}{$type.name}_{$typemapName}{literal}` WHERE ".$whereSql;
		$this->mDb->query( $query, $bindVars );

		if( $this->mDb->query( $query, $bindVars ) ){
			$ret = TRUE;
		}

		return $ret;
	}

	function list{/literal}{$typemapName|ucfirst}{literal}( $pParamHash = NULL ){
		$ret = $bindVars = array();

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql = " WHERE `{/literal}{$type.name}_{$typemapName}{literal}`.content_id = ?";
		} else {
			$bindVars[] = $this->mContentId;
			$whereSql = " WHERE `{/literal}{$type.name}_{$typemapName}{literal}`.content_id = ?";
		}

		$query = "{/literal}SELECT {if $typemap.sequence}`{$typemapName}_id`,{/if}
{foreach from=$typemap.fields key=fieldName item=field name=fields}
 `{$fieldName}`{if !$smarty.foreach.fields.last},{/if}
{/foreach}
 FROM `{$type.name}_{$typemapName}`"{literal}.$whereSql;
		$ret = $this->mDb->getArray( $query, $bindVars );

		return $ret;
	}

	/**
	 * preview{/literal}{$typemapName|ucfirst}{literal}Fields prepares the fields in this type for preview
	 */
	 function preview{/literal}{$typemapName|ucfirst}{literal}Fields(&$pParamHash) {
		$this->prep{/literal}{$typemapName|ucfirst}{literal}Verify();
		if (!empty($pParamHash['{/literal}{$type.name}']['{$typemapName}']{literal})) {
			foreach($pParamHash['{/literal}{$type.name}']['{$typemapName}']{literal} as $key => $data) {
				LibertyValidator::preview(
					$this->mVerification['{/literal}{$type.name}_{$typemapName}{literal}'],
					$pParamHash['{/literal}{$type.name}']['{$typemapName}'][$key]{literal},
					$this, $pParamHash['{/literal}{$typemapName}{literal}_store'][$key]);
			}
		}
	}

	/**
	 * validate{/literal}{$typemapName|ucfirst}{literal}Fields validates the fields in this type
	 */
	function validate{/literal}{$typemapName|ucfirst}{literal}Fields(&$pParamHash) {
		$this->prep{/literal}{$typemapName|ucfirst}{literal}Verify();
		if (!empty($pParamHash['{/literal}{$type.name}']['{$typemapName}']{literal})) {
			foreach($pParamHash['{/literal}{$type.name}']['{$typemapName}']{literal} as $key => &$data) {
				LibertyValidator::validate(
					$this->mVerification['{/literal}{$type.name}_{$typemapName}{literal}'],
					$pParamHash['{/literal}{$type.name}']['{$typemapName}'][$key]{literal},
					$this, $pParamHash['{/literal}{$typemapName}{literal}_store'][$key]);
			}
		}
	}

	/**
	 * prep{/literal}{$typemapName|ucfirst}{literal}Verify prepares the object for input verification
	 */
	function prep{/literal}{$typemapName|ucfirst}{literal}Verify() {
		if (empty($this->mVerification['{/literal}{$type.name}_{$typemapName}{literal}'])) {
{/literal}
{foreach from=$typemap.fields key=fieldName item=field name=fields}
	 		/* Validation for {$fieldName} */
{if !empty($field.validator.type) && $field.validator.type != "no-input"}
			$this->mVerification['{$type.name}_{$typemapName}']['{$field.validator.type}']['{$fieldName}'] = array(
				'name' => '{$fieldName}',
{foreach from=$field.validator key=k item=v name=keys}
{if $k != 'type'}
				'{$k}' => {if is_array($v)}array(
{foreach from=$v key=vk item=vv name=values}
					{if is_numeric($vk)}{$vk}{else}'{$vk}'{/if} => '{$vv}'{if !$smarty.foreach.values.last},{/if}

{/foreach}
					){else}'{$v}'{/if}{if !$smarty.foreach.keys.last},{/if}

{/if}
{/foreach}
			);
{elseif empty($field.validator.type)}
			$this->mVerification['{$type.name}_{$typemapName}']['null']['{$fieldName}'] = TRUE;
{/if}
{/foreach}
{literal}
		}
	}

	// }}}
{/literal}
