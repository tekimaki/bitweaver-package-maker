<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim: :set fdm=marker : */
{{include file="php_file_header.tpl"}}
/**
* {{$config.class_name}} class
* {{$config.description}}
*
* @version $Revision: $
* @class {{$config.class_name}}
*/

/**
 * Initialize
 */
require_once( CONFIG_PKG_PATH.'{{$config.package}}/plugins/{{$config.plugin}}/plugin_inc.php' );
require_once( {{$config.base_package|upper}}_PKG_PATH.'{{$config.base_class}}.php' );
require_once( LIBERTY_PKG_PATH . 'LibertyValidator.php' );

{{include file="custom_require_inc.php.tpl"}}


class {{$config.class_name}} extends {{$config.base_class}} {

	/**
	 * Primary key for parent object when instantiated
	 */
	var $mContentId;

	var $mVerification;

	var $mSchema;

	var $mServiceContent;

	public function __construct( $pContentId=NULL ) {
		{{$config.base_class}}::{{$config.base_class}}();
		$this->mContentId = $pContentId;
	}

	
    /**
     * Check mContentId to establish if the object has been loaded with a valid record
     */
    function isValid() {
        return( BitBase::verifyId( $this->mContentId ) );
    }

	/**
	 * setServiceContent
	 */
	function setServiceContent( &$pObject ){
		$this->mServiceContent = &$pObject;
	}


	/**
	 * getSchema prepares the object for input verification
	 */
	public function getSchema() {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
		if (empty($this->mSchema['{{$config.name}}_{{$typemapName}}'])) {
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
	 		/* Schema for {{$config.name}} */
			$this->mSchema['{{$config.name}}_{{$typemapName}}']['{{$fieldName}}'] = array(
				'name' => '{{$fieldName}}',
				'type' => '{{$field.validator.type|default:'null'}}',
				'label' => '{{$field.name|addslashes}}',
				'help' => '{{$field.help|addslashes}}',
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

	// Getters for reference column options - return associative arrays formatted for generating html select inputs
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{* fields *}}
{{foreach from=$typemap.fields key=fieldName item=field}}
{{if $field.validator.type == 'reference' && $field.input.type == 'select'}}
	function get{{$fieldName|replace:" ":""}}Options( $pParamHash=array() ){
		$bindVars = array();
		$joinSql = $whereSql = "";
{{assign var=customlabel value="`$fieldName`_options"}}
		/* =-=- CUSTOM BEGIN: {{$customlabel}} -=-= */
{{if !empty($customBlock.$customlabel)}}
{{$customBlock.$customlabel}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$customlabel}} -=-= */
		$query = "{{$field.input.optionsHashQuery}} $joinSql $whereSql";
		return $this->mDb->getAssoc( $query, $bindVars );
	}

{{/if}}{{/foreach}}{{* end fields loop *}}
{{* graph *}}
{{foreach from=$typemap.graph key=vertex item=field}}
{{if $field.validator.type == 'reference' && $field.input.type == 'select'}}
	function get{{$field.field|ucfirst}}Options( $pParamHash=array() ){
		$bindVars = array();
		$selectSql = $joinSql = $whereSql = "";
		$LC = new LibertyContent();
		$LC->getServicesSql( 'content_list_sql_function', $selectSql, $joinSql, $whereSql, $bindVars, NULL, $pParamHash );
{{foreach from=$field.input.type_limit item=ctype}}
		$whereSql = "AND lc.`content_type_guid` = ?";
		$bindVars[] = "{{$ctype}}";
{{/foreach}}
{{assign var=customlabel value="`$field.field`_options"}}
		/* =-=- CUSTOM BEGIN: {{$customlabel}} -=-= */
{{if !empty($customBlock.$customlabel)}}
{{$customBlock.$customlabel}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$customlabel}} -=-= */
		$whereSql = preg_replace( '/^[\s]*AND\b/i', 'WHERE ', $whereSql );
{{if $vertex eq 'tail'}}
		$query = "SELECT a.tail_content_id, lc.title 
{{else}}
		$query = "SELECT a.head_content_id, lc.title 
{{/if}}
				  FROM liberty_edge lc 
				  INNER JOIN liberty_content lc ON a.content_id = lc.content_id 
				  $joinSql 
				  $whereSql";
		return $this->mDb->getAssoc( $query, $bindVars );
	}

{{/if}}{{/foreach}}{{* end graph loop *}}
{{/foreach}}{{* end typemap loop *}}



{{include file="typemaps_methods_inc.php.tpl"}}

{{include file="custom_methods_inc.php.tpl"}}
}

{{include file="plugin_service_functions_inc.php.tpl"}}

{{include file="custom_functions_inc.php.tpl"}}
