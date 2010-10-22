<?php /* -*- Mode: php{} tab-width: 4{} indent-tabs-mode: t{} c-basic-offset: 4{} -*- */
/* vim: :set fdm=marker : */
/**
 * $Header: $
 *
 * Copyright (c) 2010 Tekimaki LLC http://tekimaki.com
 * Copyright (c) 2010 will james will@tekimaki.com
 * Copyright (c) 2010 nick palmer@overtsolutions.com
 *
 * All Rights Reserved. See below for details and a complete list of authors.
 * Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details
 *
 * $Id: $
 * @package pkgmkr
 * @subpackage functions
 */

class TypeRenderer extends aRenderer{

	/**
	 * prepConfig
	 * prepares the config of a single 'type' hash
	 * if the package has multiple types this method 
	 * should be called recursively
	 */
	public static function prepConfig(&$config){
		// set default title
		if( !isset( $config['title'] ) ){
			$config['title'] = TRUE;
		}

		// set default data (@TODO whats this? see line 448 in TypeClass.php.tpl)
		if( !isset( $config['data'] ) ){
			$config['data'] = TRUE;
		}

		// set default class name
		if( empty( $config['class_name'] ) )
			$config['class_name'] = 'Bit'.(ucfirst( $config['type_name'] ));

		// prep form fields
		$excludeFields = array( 'title', 'data', 'summary' );			// yaml may specify settings for auto generated fields in the field list, so we exclude them from requirements checks
		self::prepFieldsConfig( $config, $excludeFields );

		return $config;
	}


	public static function prepFieldsConfig( &$schema, &$excludeFields = array() ){
		if( !empty( $schema['fields'] ) ){
			foreach ($schema['fields'] as $fieldName => &$field) {
				if( empty( $excludeFields ) || !in_array( $fieldName, $excludeFields ) ){
					// prep input hash

					// default type inherited from validator settings
					if( empty( $field['input']['type'] ) ){
						if (!empty($field['validator']['type'])) {
							$field['input']['type'] = $field['validator']['type'];
						} else {
							error("Missing validator for: " . $field['name'], false);
							print_r($field);
							error("Aborting.", true);
						}
					}

					// convenience
					$input = &$field['input'];
					$validator = &$field['validator'];

					switch( $input['type'] ){
					case 'select':
						// default select from a table
						$input['source'] = !empty( $input['source'] )?$input['source']:'table';
						switch( $input['source'] ){
						case 'table':
							// create select menu building blocks
							// a hash name
							$optionsHashName = $fieldName.'_options';

							// list sql
							$tableBPrefix = !empty( $input['desc_column'] )?'b':'a';
							$joinColumn = !empty( $input['join_column'] )?$input['join_column']:'content_id'; //default to liberty_content as is most common

							// create sql for loading up a select list of options
							$optionsHashQuery = "SELECT a.".$validator['column'].", ".$tableBPrefix.".".$input['desc_column']." FROM ".$validator['table']." a"; 
							$optionsHashQuery .= !empty( $input['desc_table'] )?" INNER JOIN ".$input['desc_table']." ".$tableBPrefix." ON a.".$joinColumn." = ".$tableBPrefix.".".$joinColumn:"";

							// set references to the hash name and the query
							$input['optionsHashName'] = $optionsHashName;
							$input['optionsHashQuery'] = $optionsHashQuery; 
							break;
						case 'dataset':
							// set reference to the hash name
							$input['optionsHashName'] = $input['dataset'].'Options';
							break;
						}
						break;
					}

					// prep js
					if( !empty($input['js']) ){
						// make mixedCase js handler function names
						// assembled from two parts: the js handler name e.g. onclick etc, and the field name e.g. myfield_id => onClickMyfieldId
						foreach( $input['js'] as $handler ){
							preg_match( '/(^on)(.*)/', $handler, $hmatches ); 
							$fmatches = explode( '_', $fieldName );
							$suffix = "";
							while (list($key, $val) = each($fmatches)) {
								$suffix .= ucfirst($val);
							}
							$funcName = $hmatches[1].ucfirst($hmatches[2]).$suffix;

							// set references to the handler name for tpls to use
							$schema['js']['funcs'][] = $funcName;
							$input['jshandlers'][$handler] = $schema['class_name'].'.'.$funcName;
						}
					}
				}
			}
		}
	}


	public static function convertName( $file, $config, $params = array() ){
		$tmp_file = preg_replace("/type/", strtolower($params['type']), $file);
		return preg_replace("/TypeClass/", $params['class_name'], $tmp_file);
	}

	public static function renderFiles( $config, $dir, $files ){ 
		if( !empty( $config['types'] ) ){
			foreach($config['types'] as $type => $params) {
				global $gBitSmarty;
				$params['name'] = $params['type'] = $type;
				$gBitSmarty->assign('type', $params);
				foreach ($files as $file) {
					$render_file = PackageRenderer::convertName(TypeRenderer::convertName($file, $config, $params), $config);
					$template = $file.".tpl";
					$prefix = TypeRenderer::getTemplatePrefix($file, $params);
					// Render the file
					TypeRenderer::renderFile($dir, $render_file, $template, $config, $prefix);
				}
			}
		}
	}

}
