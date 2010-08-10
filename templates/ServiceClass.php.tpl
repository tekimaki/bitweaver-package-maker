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

	var $mSchema;

	public function __construct( $pContentId=NULL ) {
		{{$service.base_class}}::{{$service.base_class}}();
		$this->mContentId = $pContentId;
	}

{{* @TODO This only really works if the table has a sequnenced column, need some other way of getting a unique value if desired *}}
{{if $service.sequence}}
	/**
	 * load a row from the {{$service.name}} table 
	 */
	 function load( $p{{$service.name|ucfirst}}Id = NULL ){
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
{{/if}}

{{if $service.sequence}}
	/**
	 * stores one or more records in the {{$service.name}} table
	 */
	function store( &$pParamHash ){
		if( $this->verify( $pParamHash ) ) {
			if( !empty( $pParamHash['{{$service.name}}_store'] )){
				$table = '{{$service.name}}';
				$this->mDb->StartTrans();
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

				/* =-=- CUSTOM BEGIN: store -=-= */
{{if !empty($customBlock.store)}}
{{$customBlock.store}}
{{else}}

{{/if}}
				/* =-=- CUSTOM END: store -=-= */

				$this->mDb->CompleteTrans();
			}
		}
	}
{{else}}
	/**
	 * stores a single record in the {{$service.name}} table
	 */
	function store( &$pParamHash ){
		if( $this->verify( &$pParamHash ) ) {
			if ( !empty( $pParamHash['{{$service.name}}_store'] )){
				$table = '{{$service.name}}';
				$this->mDb->StartTrans();
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$service.name}}_store'] );
			}

			/* =-=- CUSTOM BEGIN: store -=-= */
{{if !empty($customBlock.store)}}
{{$customBlock.store}}
{{else}}

{{/if}}
			/* =-=- CUSTOM END: store -=-= */

			$this->mDb->CompleteTrans();
		}
	}
{{/if}}

{{* @TODO build out mixed storage - this is very incomplete 
	/**
	 * stores multiple records in the {{$service.name}} table
{{if !$service.sequence && $service.base_package == "liberty"}}	 * uses bulk delete to avoid trying to store duplicate records{{/if}} 
	 */
	function storeMixed( &$pParamHash ){
{{if !$service.sequence && $service.base_package == "liberty"}}
		$query = "DELETE FROM `{{$service.name}}` WHERE `content_id` = ?";
{{/if}}
		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
		$this->store( $pParamHash );
	}
*}}

	/** 
	 * verifies a data set for storage in the {{$service.name|ucfirst}} table
	 * data is put into $pParamHash['{{$service.name}}_store'] for storage
	 */
	function verify( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
		$this->validateFields($pParamHash);

		/* =-=- CUSTOM BEGIN: verify -=-= */
{{if !empty($customBlock.verify)}}
{{$customBlock.verify}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: verify -=-= */

		return( count( $this->mErrors )== 0 );
	}

	function expunge( &$pParamHash ){
		$ret = FALSE;
		$this->mDb->StartTrans();
		$bindVars = array();
		$whereSql = "";

{{if $service.sequence}}
		// limit results by {{$service.name}}_id
		if( !empty( $pParamHash['{{$service.name}}_id'] ) ){
			$bindVars[] = $pParamHash['{{$service.name}}_id'];
			$whereSql .= "`{{$service.name}}_id` = ?";
		}
{{elseif $service.base_package == "liberty"}}
		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql .= "`content_id` = ?";
		}
{{else}}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
{{if $field.schema.primary}}
		// limit results by {{$fieldName}}
		if( !empty( $pParamHash['{{$fieldName}}'] ) ){
			$bindVars[] = $pParamHash['{{$fieldName}}'];
			$whereSql .= " AND `{{$fieldName}}` = ?";
{{if !$field.validator.required}}
		}elseif( isset( $pParamHash['{{$fieldName}}'] ) ){
			$whereSql .= " AND `{{$fieldName}}` IS NULL";
{{/if}}
		}
{{/if}}
{{/foreach}}
{{/if}}

		/* =-=- CUSTOM BEGIN: expunge -=-= */
{{if !empty($customBlock.expunge)}}
{{$customBlock.expunge}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: expunge -=-= */

		if( !empty( $whereSql ) ){
			$whereSql = preg_replace( '/^[\s]*AND\b/i', 'WHERE ', $whereSql );
		}

		$query = "DELETE FROM `{{$service.name}}` ".$whereSql;

		if( $this->mDb->query( $query, $bindVars ) ){
			$ret = TRUE;
		}

		$this->mDb->CompleteTrans();
		return $ret;
	}

	function getList( &$pParamHash = NULL ){
		$ret = $bindVars = array();
		$whereSql = "";

{{if $service.base_package == "liberty"}}
		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql = " AND `{{$service.name}}`.content_id = ?";
		} elseif ( $this->isValid() ) ) {
			$bindVars[] = $this->mContentId;
			$whereSql = " AND `{{$service.name}}`.content_id = ?";
		}

{{/if}}
{{foreach from=$service.fields key=fieldName item=field name=fields}}
{{if $field.schema.primary}}
		// limit results by {{$fieldName}}
		if( !empty( $pParamHash['{{$fieldName}}'] ) ){
			$bindVars[] = $pParamHash['{{$fieldName}}'];
			$whereSql .= " AND `{{$fieldName}}` = ?";
		}

{{/if}}
{{/foreach}}
		/* =-=- CUSTOM BEGIN: getList -=-= */
{{if !empty($customBlock.getList)}}
{{$customBlock.getList}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: getList -=-= */

		if( !empty( $whereSql ) ){
			$whereSql = preg_replace( '/^[\s]*AND\b/i', 'WHERE ', $whereSql );
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
	 * preview prepares the fields in this type for preview
	 */
	 function previewFields( &$pParamHash ) {
		$this->prepVerify();
		if (!empty($pParamHash['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'])) {
			LibertyValidator::preview(
				$this->mVerification['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'],
				$pParamHash['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'],
				$this, $pParamHash['{{$service.name}}_store']);
		}
	}

	/**
	 * validateFields validates the fields in this type
	 */
	function validateField( &$pParamHash ) {
		$this->prepVerify();
		if (!empty($pParamHash['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'])) {
			LibertyValidator::validate(
				$this->mVerification['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'],
				$pParamHash['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'],
				$this, $pParamHash['{{$service.name}}_store']);
		}
	}

	/**
	 * prepVerify prepares the object for input verification
	 */
	function prepVerify() {
		if (empty($this->mVerification['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'])) {

{{foreach from=$service.fields key=fieldName item=field name=fields}}
	 		/* Validation for {{$fieldName}} */
{{if !empty($field.validator.type) && $field.validator.type != "no-input"}}
			$this->mVerification['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}']['{{$field.validator.type}}']['{{$fieldName}}'] = array(
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
		$this->mVerification['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}']['null']['{{$fieldName}}'] = TRUE;
{{/if}}
{{/foreach}}

		}
	}

	/**
	 * returns the data schema by database table
	 */
	public function getSchema() {
		if (empty($this->mSchema['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}'])) {

{{foreach from=$service.fields key=fieldName item=field name=fields}}
	 		/* Schema for {{$fieldName}} */
			$this->mSchema['{{$service.name}}{{if $service.base_package == "liberty"}}_data{{/if}}']['{{$fieldName}}'] = array(
				'name' => '{{$fieldName}}',
				'type' => '{{$field.validator.type|default:'null'}}',
				'label' => '{{$field.name}}',
				'help' => '{{$field.help}}',
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
{{/foreach}}
		}

{{foreach from=$service.typemaps key=typemapName item=typemap}}
		if (empty($this->mSchema['{{$typeName}}_{{$typemapName}}'])) {
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
	 		/* Schema for {{$fieldName}} */
			$this->mSchema['{{$typeName}}_{{$typemapName}}']['{{$fieldName}}'] = array(
				'name' => '{{$fieldName}}',
				'type' => '{{$field.validator.type|default:'null'}}',
				'label' => '{{$field.name}}',
				'help' => '{{$field.help}}',
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
{{/foreach}}
		}
{{/foreach}}

		return $this->mSchema;
	}

{{literal}}
	// {{{ =================== Custom Helper Mthods  ====================
{{/literal}}

	/* This section is for any helper methods you wish to create */
	/* =-=- CUSTOM BEGIN: methods -=-= */
{{if !empty($customBlock.methods)}}
{{$customBlock.methods}}
{{else}}

{{/if}}
	/* =-=- CUSTOM END: methods -=-= */

{{literal}}
	// }}} -- end of Custom Helper Methods
{{/literal}}

}

{{foreach from=$service.functions item=func}}
function {{$serviceName}}_{{$func}}( $pObject, $pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$serviceName|strtoupper}} ) ){
{{if $func eq 'content_load'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_display'}}
		if( $pObject->isValid() ) {
			${{$serviceName}} = new {{$service.class_name}}(); 
			$listHash = array( 'content_id' => $pObject->mContentId );
			$pObject->mInfo['{{$serviceName}}'] = ${{$serviceName}}->getList( $listHash );
		}
{{elseif $func eq 'content_list'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_list_history'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_preview'}}
		${{$serviceName}} = new {{$service.class_name}}(); 
		$pObject->mInfo['{{$serviceName}}'] = ${{$serviceName}}->previewFields( $pParamHash );
{{elseif $func eq 'content_edit'}}
		// pass through to display to load up content data
		{{$serviceName}}_content_display( $pObject, $pParamHash );
{{elseif $func eq 'content_store'}}
		${{$serviceName}} = new {{$service.class_name}}( $pObject->mContentId ); 
		if( !${{$serviceName}}->store( $pParamHash ) ){
			$pObject->setError( '{{$serviceName}}', ${{$serviceName}}->mErrors );
		}
{{elseif $func eq 'content_expunge'}}
		${{$serviceName}} = new {{$service.class_name}}( $pObject->mContentId ); 
		if( !${{$serviceName}}->expunge() ){
			$pObject->setError( '{{$serviceName}}', ${{$serviceName}}->mErrors );
		}
{{elseif $func eq 'content_load_sql'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = " {{foreach from=$service.fields key=fieldName item=field name=fields}},{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] = " LEFT JOIN `".BIT_DB_PREFIX."{{$serviceName}}` {{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}} ON ( lc.`content_id`={{$serviceName}}.`content_id` )";
		$ret['where_sql'] = "";
		return $ret;
{{elseif $func eq 'content_list_sql'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = " {{foreach from=$service.fields key=fieldName item=field name=fields}},{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] = " LEFT JOIN `".BIT_DB_PREFIX."{{$serviceName}}` {{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}} ON ( lc.`content_id`={{$serviceName}}.`content_id` )";
		$ret['where_sql'] = "";
{{*
        // return the values sent for pagination / url purposes
        $pParamHash['listInfo']['{{$serviceName}}'] = $pParamHash['{{$serviceName}}'];
        $pParamHash['listInfo']['ihash']['{{$serviceName}}'] = $pParamHash['{{$serviceName}}'];
*}}
		return $ret;
{{elseif $func eq 'comment_store'}}
		if( $pObject->isContentType( BITCOMMENT_CONTENT_TYPE_GUID ) ){
		{{* likely will be custom behavior *}}
		}
{{/if}}
	}
}
{{/foreach}}
