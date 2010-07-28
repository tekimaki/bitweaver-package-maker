<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim: :set fdm=marker : */
{{include file="bitpackage:pkgmkr/php_file_header.tpl"}}
/**
* {{$service.class_name}} class
* {{$service.description}}
*
* @version $Revision: $
* @class {{$service.class_name}}
*/

/**
 * Initialize
 */
require_once( {{$service.base_package|upper}}_PKG_PATH.'{{$service.base_class}}.php' );
require_once( LIBERTY_PKG_PATH . 'LibertyValidator.php' );

/* =-=- CUSTOM BEGIN: require -=-= */
{{if !empty($customBlock.require)}}
{{$customBlock.require}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: require -=-= */


class {{$service.class_name}} extends {{$service.base_class}} {

	/**
	 * Primary key for parent object when instantiated
	 */
	var $mContentId;

	var $mVerification;

	public function __construct( $pContentId=NULL ) {
		LibertyBase::LibertyBase();
		$this->mContentId = $pContentId;
	}

{{* @TODO This only really works if the table has a sequnenced column, need some other way of getting a unique value if desired *}}
{{if $service.sequence}}
	/**
	 * load a row from the {{$service.name}} table 
	 */
	 function load{{$service.name|ucfirst}}( $p{{$service.name|ucfirst}}Id = NULL ){
		$ret = array();
		if( $this->verifyId( $p{{$service.name|ucfirst}}Id ) ){
			$query = "SELECT `{{$service.name}}_id` as hash_key, `{{$service.name}}_id`,{{foreach from=$service.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$service.name}}` WHERE `{{$service.name}}`.{{$service.name}}_id = ?";
			$ret = $this->mDb->getAssoc( $query, $bindVars );
		}
		return $ret;
	}

	/**
	 * stores one or more records in the {{$service.name}} table
	 */
	function store{{$service.name|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{{$service.name|ucfirst}}( $pParamHash ) ) {
			$table = '{{$service.name}}';
			if( !empty( $pParamHash['{{$service.name}}_store'] )){
				foreach ($pParamHash['{{$service.name}}_store'] as $key => &$data) {
{{if $service.base_package == "liberty"}}
					if (!empty($pParamHash['{{$service.name}}']['content_id'])) {
						$data['content_id'] = $pParamHash['{{$service.name}}']['content_id'];
					} else {
						$data['content_id'] = $this->mContentId;
					}
{{/if}}
					// {{$service.name}} id is set update the record
					if( !empty( $data['{{$service.name}}_id'] ) ){
						$locId = array( '{{$service.name}}_id' => $data['{{$service.name}}_id'] );
						// unset( $data['{{$service.name}}_id'] );
						$result = $this->mDb->associateUpdate( $table, $data, $locId );
					// {{$service.name}} id is not set create a new record
					}else{
						$data['{{$service.name}}_id'] = $this->mDb->GenID('{{$service.name}}_id_seq');
						$result = $this->mDb->associateInsert( $table, $data );
					}
				}
			}
		}
	}
{{else}}
	/**
	 * stores a single record in the {{$service.name}} table
	 */
	function store{{$service.name|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{{$service.name|ucfirst}}( &$pParamHash ) ) {
			if ( !empty( $pParamHash['{{$service.name}}_store'] )){
				$table = '{{$service.name}}';
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$service.name}}_store'] );
			}
		}
	}
{{/if}}

	/**
	 * stores multiple records in the {{$service.name}} table
{{if !$service.sequence}}	 * uses bulk delete to avoid trying to store duplicate records{{/if}} 
	 */
	function store{{$service.name|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){

		$query = "DELETE FROM `{{$service.name}}` WHERE `content_id` = ?";

		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
		$this->store{{$service.name|ucfirst}}( $pParamHash, $skipVerify );
	}

	/** 
	* verifies a data set for storage in the {{$service.name|ucfirst}} table
	 * data is put into $pParamHash['{{$service.name}}_store'] for storage
	 */
	function verify{{$service.name|ucfirst}}( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
		$this->validate{{$service.name|ucfirst}}Fields($pParamHash);
		return( count( $this->mErrors )== 0 );
	}

	function expunge{{$service.name|ucfirst}}( &$pParamHash ){
		$ret = FALSE;
		$bindVars = array();
		$whereSql = "";

{{if $service.sequence}}
		// limit results by {{$service.name}}_id
		if( !empty( $pParamHash['{{$service.name}}_id'] ) ){
			$bindVars[] = $pParamHash['{{$service.name}}_id'];
			$whereSql .= "`{{$service.name}}_id` = ?";
		}

{{/if}}

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql .= "`content_id` = ?";
		}

		$query = "DELETE FROM `{{$service.name}}` WHERE ".$whereSql;
		$this->mDb->query( $query, $bindVars );

		if( $this->mDb->query( $query, $bindVars ) ){
			$ret = TRUE;
		}

		return $ret;
	}

	function list{{$service.name|ucfirst}}( $pParamHash = NULL ){
		$ret = $bindVars = array();

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql = " WHERE `{{$service.name}}`.content_id = ?";
		} else {
			$bindVars[] = $this->mContentId;
			$whereSql = " WHERE `{{$service.name}}`.content_id = ?";
		}

		$query = "SELECT {{if $service.sequence}}`{{$service.name}}_id` as hash_key, `{{$service.name}}_id`,{{/if}}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$service.name}}`".$whereSql;
{{if $service.sequence}}
		$ret = $this->mDb->getAssoc( $query, $bindVars );
{{else}}
		$ret = $this->mDb->getArray( $query, $bindVars );
{{/if}}
		return $ret;
	}

	/**
	 * preview{{$service.name|ucfirst}}Fields prepares the fields in this type for preview
	 */
	 function preview{{$service.name|ucfirst}}Fields(&$pParamHash) {
		$this->prep{{$service.name|ucfirst}}Verify();
		if (!empty($pParamHash['{{$service.name}}'])) {
			foreach($pParamHash['{{$service.name}}'] as $key => $data) {
				LibertyValidator::preview(
					$this->mVerification['{{$service.name}}'],
					$pParamHash['{{$service.name}}'][$key],
					$this, $pParamHash['{{$service.name}}_store'][$key]);
			}
		}
	}

	/**
	 * validate{{$service.name|ucfirst}}Fields validates the fields in this type
	 */
	function validate{{$service.name|ucfirst}}Fields(&$pParamHash) {
		$this->prep{{$service.name|ucfirst}}Verify();
		if (!empty($pParamHash['{{$service.name}}'])) {
			foreach($pParamHash['{{$service.name}}'] as $key => &$data) {
				LibertyValidator::validate(
					$this->mVerification['{{$service.name}}'],
					$pParamHash['{{$service.name}}'][$key],
					$this, $pParamHash['{{$service.name}}_store'][$key]);
			}
		}
	}

	/**
	 * prep{{$service.name|ucfirst}}Verify prepares the object for input verification
	 */
	function prep{{$service.name|ucfirst}}Verify() {
		if (empty($this->mVerification['{{$service.name}}'])) {

{{foreach from=$service.fields key=fieldName item=field name=fields}}
	 		/* Validation for {{$fieldName}} */
{{if !empty($field.validator.type) && $field.validator.type != "no-input"}}
			$this->mVerification['{{$service.name}}']['{{$field.validator.type}}']['{{$fieldName}}'] = array(
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
			$this->mVerification['{{$service.name}}']['null']['{{$fieldName}}'] = TRUE;
{{/if}}
{{/foreach}}

		}
	}

}

