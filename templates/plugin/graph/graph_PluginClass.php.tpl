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

/* =-=- CUSTOM BEGIN: require -=-= */
{{if !empty($customBlock.require)}}
{{$customBlock.require}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: require -=-= */


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

	function store(){
        // expunge first then we repopulate the record
        $this->expunge( $pParamHash );

        if( $this->isValid() ){
            // must have a tail content id 
            $pParamHash['liberty_edge']['tail_content_id'] = $this->mContentId;
            // must have a head content id to store
            if( !empty( $pParamHash['{{$config.graph.head.field}}'] ) ){
                $pParamHash['liberty_edge']['head_content_id'] = $pParamHash['{{$config.graph.head.field}}'];
                parent::store( $pParamHash );
            }
        }
        return count( $this->getErrors() == 0 );
	}

	function expunge(){
        /* =-=- CUSTOM BEGIN: expunge -=-= */
{{if !empty($customBlock.expunge)}}
{{$customBlock.expunge}}
{{else}}

{{/if}}
        /* =-=- CUSTOM END: expunge -=-= */

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

        /* =-=- CUSTOM BEGIN: getList -=-= */
{{if !empty($customBlock.getList)}}
{{$customBlock.getList}}
{{else}}

{{/if}}
        /* =-=- CUSTOM END: getList -=-= */

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

{{include file="plugin_service_functions_inc.php.tpl"}}

{{literal}}
// {{{ =================== Custom Helper Functions  ====================
{{/literal}}

/* This section is for any helper functions you wish to create */
/* =-=- CUSTOM BEGIN: functions -=-= */
{{if !empty($customBlock.functions)}}
{{$customBlock.functions}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: functions -=-= */

{{literal}}
// }}} -- end of Custom Helper Methods
{{/literal}}
