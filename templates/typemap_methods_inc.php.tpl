{literal}
	// {{{ =================== {/literal}{$typemapName|ucfirst}{literal} Handlers  ====================

{/literal}{if $typemap.sequence}{literal}
	/**
	 * load a row from the {/literal}{$typeName}_{$typemapName}{literal} table 
	 * @TODO This only really works if the table has a sequnenced column, need some other way of getting a unique value if desired
	 */
	 function load{/literal}{$typemapName|ucfirst}{literal}( $p{/literal}{$typemapName|ucfirst}{literal}Id = NULL ){
		$ret = array();
		if( $this->verifyId( $p{/literal}{$typemapName|ucfirst}{literal}Id ) ){
			$query = "{/literal}SELECT `{$typemapName}_id`,{foreach from=$typemap.fields key=fieldName item=field name=fields}
 `{$fieldName}`{if !$smarty.foreach.fields.last},{/if}
{/foreach}
 FROM `{$typeName}_{$typemapName}` WHERE `{$typeName}_{$typemapName}`.{$typemapName}_id = ?{literal}";
			$ret = $this->mDb->getArray( $query, $bindVars );
		}
		return $ret;
	}
{/literal}{/if}{literal}

	// stores a single record in the {$typeName}_{$typemapName|ucfirst} table
	function store{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ){
		if( $this->verify{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ) ){
		}
	}

	// verifies a data set for storage in the {$typeName}_{$typemapName|ucfirst} table
	function verify{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
		$this->validateFields($pParamHash);

		return( count( $this->mErrors )== 0 );
	}

	function expunge{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ){
		$ret = FALSE;
		$bindVars = array();

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
		}

{/literal}{if $typemap.sequence}{literal}
		// limit results by {/literal}{$typemapName}{literal}_id
		if( !empty( $pParamHash['{/literal}{$typemapName}{literal}_id'] ) ){
			$bindVars[] = $pParamHash['{/literal}{$typemapName}{literal}_id'];
		}{/literal}{/if}{literal}

		if( $this->mDb->query( $query, $bindVars ) ){
			$ret = TRUE;
		}

		return $ret;
	}

	function list{/literal}{$typemapName|ucfirst}{literal}( &$pParamHash ){
		$ret = $bindVars = array();

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
		}

{/literal}{if $typemap.sequence}{literal}
		// limit results by {/literal}{$typemapName}{literal}_id
		if( !empty( $pParamHash['{/literal}{$typemapName}{literal}_id'] ) ){
			$bindVars[] = $pParamHash['{/literal}{$typemapName}{literal}_id'];
		}{/literal}{/if}{literal}

		$bindVars = array( $contentId );
		$query = "{/literal}SELECT {if $typemap.sequence}`{$typemapName}_id`,{/if}
{foreach from=$typemap.fields key=fieldName item=field name=fields}
 `{$fieldName}`{if !$smarty.foreach.fields.last},{/if}
{/foreach}
 FROM `{$typeName}_{$typemapName}` WHERE `{$typeName}_{$typemapName}`.content_id = ?{literal}";
		$ret = $this->mDb->getArray( $query, $bindVars );

		return $ret;
	}

	// }}}
{/literal}
