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

class PackageRenderer extends aRenderer{
	public static function validateConfig( $config ){
		// TODO: Would be nice to genericize these checks
		// so that you would just modify a file in resources
		// to modify what is validated instead of writing code
		// here. Would make the generator a more flexible code
		// generator.
		if (empty($config['package'])) {
			error("A package is required.");
		}

		if (empty($config['description'])) {
			error("A description is required.");
		}

		if (empty($config['version'])) {
			error("A version number is required.");
		}

		// validate type class schemas
		if( !empty( $config['types'] ) ){
			foreach ($config['types'] as $name => $schema) {
				PackageRenderer::validateSchema( $config['types'], $name, $schema, 'type' );
			}
		}

		// validate service class schemas
		if( !empty( $config['services'] ) ){
			foreach ($config['services'] as $name => $schema) {
				PackageRenderer::validateSchema( $config['services'], $name, $schema, 'service' );
			}
		}

		// TODO: LOTS MORE VALIDATION HERE!!!!

		//  print_r($config);
		
		return $config;
	} 

	// Prepare any additional data based config data
	public function prepConfig( &$config ){
		// Generate a few capitalization variations
		$config['package'] = strtolower($config['package']);
		$config['PACKAGE'] = strtoupper($config['package']);
		$config['Package'] = ucfirst(strtolower($config['package']));

		if( !empty( $config['types'] ) ){
			foreach ($config['types'] as $typeName => &$type) {
				// defaults
				if( !isset( $type['title'] ) ){
					$type['title'] = TRUE;
				}
				if( !isset( $type['data'] ) ){
					$type['data'] = TRUE;
				}

				// prep form fields
				$excludeFields = array( 'title', 'data', 'summary' );			// yaml may specify settings for auto generated fields in the field list, so we exclude them from requirements checks
				if( !empty( $type['fields'] ) ){
					foreach ($type['fields'] as $fieldName => &$field) {
						if( !in_array( $fieldName, $excludeFields ) ){
							// prep input hash

							// default type inherited from validator settings
							if( empty( $field['input']['type'] ) ){
								if (!empty($field['validator']['type'])) {
										$field['input']['type'] = $field['validator']['type'];
								} else {
									vd($field);
									error("No validator for $field.", true);
								}
							}

							// convenience
							$input = &$field['input'];
							$validator = &$field['validator'];

							switch( $input['type'] ){
								case 'select':
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
									$config['types'][$typeName]['js']['funcs'][] = $funcName;
									$input['jshandlers'][$handler] = $type['class_name'].'.'.$funcName;
								}
							}
						}
					}
				}
			}
		}
		return $config;
	}

	public function generate( $config ){
		message("Generating package: ".$config['package']);

		// Load the files we are to generate
		$gFiles = Spyc::YAMLLoad(RESOURCE_DIR.'package.yaml');

		// Locate all our templates.
		$this->locateTemplates();

		// Prepare any additional data based config data
		$this->prepConfig($config);

		// Initialize smarty
		$this->initSmarty($config);

		// Now change directory to BIT_ROOT_PATH to generate the package in
		// the root of this install.
		chdir(BIT_ROOT_PATH);

		// Now figure out the real directory and file names
		foreach ($gFiles as $file_dir => $actions) {
			$dir = $this->convertName($file_dir, $config);

			// Does the directory exist
			if (!is_dir($dir)) {
				echo " ".$dir."\n";
				if (!mkdir($dir)) {
					error("Could not create directory!");
				}
			}

			foreach ($actions as $action => $files) {
				switch( $action ){
				case "package":
						$this->renderFiles($config, $dir, $files);
					break;
				case "type":
					if ( !empty( $config['types'] ) ) {
						TypeRenderer::renderFiles($config, $dir, $files);
					}
					break;
				case "service":
					if ( !empty( $config['services'] ) ) {
						ServiceRenderer::renderFiles($config, $dir, $files);
					}
					break;
				case "copy":
					$this->copyFiles($config, $dir, $files);
					break;
				default:
					error("Unknown action: " . $action);
					break;
				}
			}
		}
	}

	public static function convertName( $file, $config, $params = array() ){
		$tmp_file = preg_replace("/package/", $config['package'], $file);
		return preg_replace("/Package/", $config['Package'], $tmp_file);
	}

	public static function renderFiles( $config, $dir, $files ){
		foreach ($files as $file) {
			$render_file = PackageRenderer::convertName($file, $config);
			$template = $file.".tpl";
			$prefix = PackageRenderer::getTemplatePrefix($file, $config);
			// Render the file
			PackageRenderer::renderFile($dir, $render_file, $template, $config, $prefix);
		}
	}

	protected function initSmarty( &$config ){ 
		parent::initSmarty();

		global $gBitSmarty;
		// Assign package in various cases to the context for
		// easier to read templates.
		$gBitSmarty->assign('package', $config['package']);
		$gBitSmarty->assign('PACKAGE', $config['PACKAGE']);
		$gBitSmarty->assign('Package', $config['Package']);

		// Assign the configuration to context
		$gBitSmarty->assign('config', $config);
	}

	public function copyFiles($config, $dir, $files) {
		foreach ($files as $file) {
			$render_file = PackageRenderer::convertName($file, $config);
			$filename = $dir."/".$render_file;

			message(" ".$filename);

			if (!copy(PKGMKR_PKG_PATH.'/'.RESOURCE_DIR.$file, $filename)) {
				error("Error copying file: $file");
			}
		}
	}

}
