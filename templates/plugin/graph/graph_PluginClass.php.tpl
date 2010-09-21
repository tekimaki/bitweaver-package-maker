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

	public function __construct( $pContentId=NULL ) {
		parent::__construct();
		$this->mContentId = $pContentId;
	}

	function store( &$pParamHash ){
        // expunge first then we repopulate the record
		if( !empty( $pParamHash['{{$config.graph.head.field}}'] ) && $this->isValid() ){
			$expungeHash = array( 'expunge_{{$config.graph.head.field}}' => $pParamHash['{{$config.graph.head.field}}'] );
        	$this->expunge( $expungeHash );

			// must have a tail content id 
			$pParamHash['liberty_edge']['tail_content_id'] = $this->mContentId;
			// must have a head content id to store
			$pParamHash['liberty_edge']['head_content_id'] = $pParamHash['{{$config.graph.head.field}}'];
			parent::store( $pParamHash );
		}
        return count( $this->getErrors() == 0 );
	}

	function expunge( &$pParamHash ){
{{include file="custom_expunge_inc.php.tpl"}}

        if( $this->isValid() ){
            $expungeHash = array();

			// limit expunge to tail_content_id
            $expungeHash['tail_content_id'] = $this->mContentId;

            // limit expunge to the head_content_id
            if( !empty( $pParamHash['expunge_{{$config.graph.head.field}}'] ) ){
                $expungeHash['head_content_id'] = $pParamHash['expunge_{{$config.graph.head.field}}'];
			}

			// @TODO might need to limit by head content_type_guid 
			// when head_content_id is empty all heads of the tail will be expunged 
			// which is likely to be more than what this service intends

            parent::expunge( $expungeHash );
        }

        return count( $this->getErrors() == 0 );
	}

    function getList( &$pParamHash = NULL ){
		$listHash = array();

        // limit results by {{$config.graph.tail.field}}
        if( !empty( $pParamHash['{{$config.graph.tail.field}}'] ) ){
			$listHash['tail_content_id'] = $pParamHash['{{$config.graph.tail.field}}'];
        }

        // limit results by {{$config.graph.head.field}}
        if( !empty( $pParamHash['{{$config.graph.head.field}}'] ) ){
			$listHash['head_content_id'] = $pParamHash['{{$config.graph.head.field}}'];
        }

{{include file="custom_getlist_inc.php.tpl"}}

        return parent::getList( $listHash );
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

	// Getters for reference column options - return associative arrays formatted for generating html select inputs
{{foreach from=$config.fields key=fieldName item=field}}
{{if $field.validator.type == 'reference' && $field.input.type == 'select'}}
	function get{{$field.name|replace:" ":""}}Options( &$pParamHash=array() ){
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

{{/if}}{{/foreach}}

{{include file="typemaps_methods_inc.php.tpl"}}

{{include file="custom_methods_inc.php.tpl"}}
}

{{include file="plugin_service_functions_inc.php.tpl"}}

{{include file="custom_functions_inc.php.tpl"}}
