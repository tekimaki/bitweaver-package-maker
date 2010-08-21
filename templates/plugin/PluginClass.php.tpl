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
		{{$config.base_class}}::{{$config.base_class}}();
		$this->mContentId = $pContentId;
	}

	/**
	 * previewFields prepares the fields in this type for preview
	 */
	function previewFields(&$pParamHash) {
		$this->prepVerify();
		LibertyValidator::preview(
		$this->mVerification['{{$config.name}}_data'],
			$pParamHash['{{$config.name}}'],
			$this->mInfo);
	}

	/**
	 * validateFields validates the fields in this type
	 */
	function validateFields(&$pParamHash) {
		$this->prepVerify();
		LibertyValidator::validate(
			$this->mVerification['{{$config.name}}_data'],
			$pParamHash['{{$config.name}}'],
			$this, $pParamHash['{{$config.name}}_store']);
	}

	/**
	 * prepVerify prepares the object for input verification
	 */
	function prepVerify() {
		if (empty($this->mVerification['{{$config.name}}_data'])) {

{{foreach from=$config.fields key=fieldName item=field name=fields}}
	 		/* Validation for {{$fieldName}} */
{{if !empty($field.validator.type) && $field.validator.type != "no-input"}}
			$this->mVerification['{{$config.name}}_data']['{{$field.validator.type}}']['{{$fieldName}}'] = array(
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
	$this->mVerification['{{$config.name}}_data']['null']['{{$fieldName}}'] = TRUE;
{{/if}}
{{/foreach}}

{{foreach from=$config.typemaps key=typemapName item=typemap}}
		// prepVerify {{$typemapName}} fieldset
		$this->prep{{$typemapName|ucfirst}}Verify();
{{/foreach}}
		}
	}

	/**
	 * prepVerify prepares the object for input verification
	 */
	public function getSchema() {
		if (empty($this->mSchema['{{$config.name}}_data'])) {

{{foreach from=$config.fields key=fieldName item=field name=fields}}
	 		/* Schema for {{$fieldName}} */
			$this->mSchema['{{$config.name}}_data']['{{$fieldName}}'] = array(
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

{{foreach from=$config.typemaps key=typemapName item=typemap}}
		if (empty($this->mSchema['{{$config.name}}_{{$typemapName}}'])) {
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
	 		/* Schema for {{$config.name}} */
			$this->mSchema['{{$config.name}}_{{$typemapName}}']['{{$fieldName}}'] = array(
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



{{if count($config.typemaps) > 0}}
{{literal}}
	// {{{ =================== TypeMap Functions for FieldSets ====================
{{/literal}}

	function verifyTypemaps( &$pParamHash ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// verify {{$typemapName}} fieldset
			$this->verify{{$typemapName|ucfirst}}($pParamHash);
{{/foreach}}

			return ( count($this->mErrors) == 0);
	}

	function previewTypemaps( &$pParamHash ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// verify {{$typemapName}} fieldset
			$this->preview{{$typemapName|ucfirst}}Fields($pParamHash);
{{/foreach}}
	}

	function storeTypemaps( &$pParamHash ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// store {{$typemapName}} fieldset
			$this->store{{$typemapName|ucfirst}}Mixed($pParamHash, TRUE);
{{/foreach}}
	}

	function expungeTypemaps() {
		if ($this->isValid() ) {
			$paramHash = array('content_id' => $this->mContentId);
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// expunge {{$typemapName}} fieldset
			$this->expunge{{$typemapName|ucfirst}}($paramHash);
{{/foreach}}
		}
	}

	function loadTypemaps() {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// load {{$typemapName}} list from sub map
			$this->mInfo['{{$typemapName}}'] = $this->list{{$typemapName|ucfirst}}();
{{/foreach}}
	}

{{literal}}
	// }}} -- end of TypeMap function for fieldsets
{{/literal}}

{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{include file="typemap_methods_inc.php.tpl" type=$config}}
{{/foreach}}
{{/if}}
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

{{include file="service_functions_inc.php.tpl"}}
