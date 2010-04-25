<?php /* -*- mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim:set ft=php ts=4 sw=4 sts=4 */
/**
 * $Header: $
 *
 * Copyright (c) 2010 bitweaver.org
 * Copyright (c) 2010 nick palmer@overtsolutions.com
 *
 * All Rights Reserved. See below for details and a complete list of authors.
 * Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details
 *
 * $Id: $
 * @package pkgmkr
 * @subpackage functions
 */


function usage($argv) {
	echo "Usage: ".$argv[0]." <package>\n\n";
	die;
}

function error($message, $fatal=TRUE) {
	echo $message;
	echo "\n";
	if ($fatal)
		die;
}

function message($message) {
	global $gVerbose;
	if ($gVerbose) {
		echo $message;
		echo "\n";
	}
}

function convert_typename($file, $type, $className) {
	$tmp_file = preg_replace("/type/", strtolower($type), $file);
	return preg_replace("/TypeClass/", $className, $tmp_file);
}

function convert_packagename($file, $config) {
	$pkg_file = preg_replace("/package/", $config['package'], $file);
	return preg_replace("/Package/", $config['Package'], $pkg_file);
}  

function copy_files($config, $dir, $files) {
	foreach ($files as $file) {
		$pkg_file = convert_packagename($file, $config);
		$filename = $dir."/".$pkg_file;

		message(" ".$filename);

		if (!copy(PKGMKR_PKG_DIR.'/'.RESOURCE_DIR.$file, $filename)) {
			error("Error copying file: $file");
		}
	}
}

function render_type_files($config, $dir, $files) {
	foreach($config['types'] as $type => $params) {
		global $gBitSmarty;
		$params['name'] = $type;
		$gBitSmarty->assign('type', $params);
		foreach ($files as $file) {
			$pkg_file = convert_packagename(convert_typename($file, $type, $params['class_name']), $config);
			$template = $file.".tpl";
			// Render the file
			render_type_file($dir, $pkg_file, $template, $config);
		}
	}
}

function generate_package_files($config, $dir, $files) {
	foreach ($files as $file) {
		$pkg_file = convert_packagename($file, $config);
		$template = $file.".tpl";
		// Render the file
		render_type_file($dir, $pkg_file, $template, $config);
	}
}

function render_type_file($dir, $file, $template, $config) {
	global $gBitSmarty;

	$filename = $dir."/".$file;
	message(" ".$filename);

	if (file_exists($filename)) {
		if (is_file($filename)) {
			if (is_readable($filename)) {
				if ($contents = file_get_contents($filename)) {
					$start_count = preg_match_all(
						'@([^a-zA-Z0-9\s]{1,2}) =-=- CUSTOM (BEGIN|END): ([^\s]*?) -=-= ([^a-zA-Z0-9\s]{1,2})@ms', $contents, $matches, PREG_OFFSET_CAPTURE | PREG_SET_ORDER);

					if ($start_count > 0) {
						for ($i = 0; $i < count($matches); $i += 2) {
							// TODO: Sanity balance check.
							$start_point = $matches[$i][4][1] + 1;
							$end_point = $matches[$i+1][0][1];
							$substring = substr($contents, $start_point, $end_point - $start_point);
							$start_point = strpos($substring, "\n");
							$end_point = strrpos($substring, "\n");
							$length = $end_point - $start_point;
							$customBlock[$matches[$i][3][0]] =
								substr($substring, $start_point + 1, $length -1);

						}
						$count = count($customBlock);
						if ($start_count != $count * 2) {
							error("Start count does not match preserved count.");
						} else {
							$gBitSmarty->assign('customBlock', $customBlock);
						}
					}
				} else {
					error("Unable to read old file: $filename");
				}
			}
		} else {
			error("$filename exists but is not a file!");
		}
	} else {
		echo "$filename is new.\n";
	}

	// Get the contents of the file from smarty
	$content = $gBitSmarty->fetch('bitpackage:pkgmkr/'.$template);
	if (!empty($content)) {
		if (!$handle = fopen($filename, 'w+')) {
			error("Cannot open file ($filename)");
		}

		// Write $content to our opened file.
		if (fwrite($handle, $content) === FALSE) {
			error("Cannot write to file ($filename)");
		}

		fclose($handle);

		if (preg_match("/.php$/", $filename)) {
			lint_file($filename);
		}
	} else {
		error("Error generating file: $filename");
	}
}

function validate_config(&$config) {
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

	foreach ($config['types'] as $typeName => $type) {
		if ( substr( $typeName,0,2 ) === 'pg' ){
			error("Do not start type names with 'pg' as there is a bug in the ADODB library which causes it to not see tables with names start with 'pg'" );
		}
		if (empty($type['class_name'])) {
			$config['types'][$typeName]['class_name'] = 'Bit'.ucfirst($typeName);
		}
		if (empty($type['content_name'])) {
			error("A content name is required for $typeName");
		}
		if (empty($type['description'])) {
			error("A description is required for $typeName");
		}
		if (empty($type['base_class'])) {
			error("A base class is required for $typeName");
		}
		if (empty($type['base_package'])) {
			error("A base package is required for $typeName");
		}

		$excludeFields = array( 'data', 'summary' );			// yaml may specify settings for auto generated fields in the field list, so we exclude them from requirements checks
		foreach ($type['fields'] as $fieldName => $field) {
			if( !in_array( $fieldName, $excludeFields ) ){
				if (empty($field['schema'])) {
					error("A schema is required for field $fieldName in type $typeName");
				}
				if (empty($field['schema']['type'])) {
					error("A type is required in the schema for field $fieldName in type $typeName");
				}
				if( !validate_reserved_sql( $fieldName ) ){
					error( "$fieldName is a reserved sql term please change the schema in type $typeName" );
				}	
			}
		}
		if( !empty( $type['typemaps'] ) ){
			foreach ($type['typemaps'] as $typemapName => $typemap) {
				foreach ($typemap['fields'] as $fieldName => $field) {
					if (empty($field['schema'])) {
						error("A schema is required for typemap $typemapName field $fieldName in type $typeName");
					}
					if (empty($field['schema']['type'])) {
						error("A type is required in the schema for typemap $typemapName field $fieldName in type $typeName");
					}
					if( !validate_reserved_sql( $fieldName ) ){
						error( "$fieldName is a reserved sql term please change the schema in typemap $typemapName" );
					}	
				}
			}
		}
	}

	// TODO: LOTS MORE VALIDATION HERE!!!!

	//  print_r($config);
	
	return $config;
}

function validate_reserved_sql( $pParam ){
	$words = array( 'column' );
	return ( !in_array( $pParam, $words ) );
}

// Prepare any additional data based config data
function prep_config(&$config){
	// Generate a few capitalization variations
	$config['package'] = strtolower($config['package']);
	$config['PACKAGE'] = strtoupper($config['package']);
	$config['Package'] = ucfirst(strtolower($config['package']));

	foreach ($config['types'] as $typeName => &$type) {
		// defaults
		if( !isset( $type['data'] ) ){
			$type['data'] = TRUE;
		}

		// prep form fields
		$excludeFields = array( 'data', 'summary' );			// yaml may specify settings for auto generated fields in the field list, so we exclude them from requirements checks
		foreach ($type['fields'] as $fieldName => &$field) {
			if( !in_array( $fieldName, $excludeFields ) ){
				// prep input hash

				// default type inherited from validator settings
				if( empty( $field['input']['type'] ) ){
					$field['input']['type'] = $field['validator']['type'];
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

	return $config;
}

function check_args($argv) {
	if (count($argv) != 2) {
		usage($argv);
	}
	if (is_file($argv[1])) {
		return validate_config(Spyc::YAMLLoad($argv[1]));
	}
	error("Not a readable file: " .$argv[1]);
}

function init_smarty($config) {
	global $gBitSmarty;

	// Assign package in various cases to the context for
	// easier to read templates.
	$gBitSmarty->assign('package', $config['package']);
	$gBitSmarty->assign('PACKAGE', $config['PACKAGE']);
	$gBitSmarty->assign('Package', $config['Package']);

	// Assign the configuration to context
	$gBitSmarty->assign('config', $config);

	// Turn off tr prefilter so those tags come out right
	$gBitSmarty->unregister_prefilter('tr');
}

function activate_pkgmkr() {
	global $gBitSystem;
	if (!$gBitSystem->isPackageActive('pkgmkr')) {
		$gBitSystem->setConfig('package_pkgmkr', 'y');
		return true;
	}
	return false;
}

function inactivate_pkgmkr($off) {
	global $gBitSystem;
	if ($off) {
		$gBitSystem->setConfig('package_pkgmkr', 'n');
	}
}

function generate_package($config) {

	message("Generating package: ".$config['package']);

	// Load the files we are to generate
	$gFiles = Spyc::YAMLLoad(RESOURCE_DIR.'files.yaml');

	// Now change directory to BIT_ROOT_PATH to generate the package in
	// the root of this install.
	chdir(BIT_ROOT_PATH);

	// Prepare any additional data based config data
	prep_config($config);

	// Initialize smarty
	init_smarty($config);

	// Now figure out the real directory and file names
	foreach ($gFiles as $file_dir => $actions) {
		$dir = convert_packagename($file_dir, $config);

		// Does the directory exist
		if (!is_dir($dir)) {
			echo " ".$dir."\n";
			if (!mkdir($dir)) {
				error("Could not create directory!");
			}
		}

		foreach ($actions as $action => $files) {
			if ($action == "package") {
				generate_package_files($config, $dir, $files);
			} elseif ($action == "type") {
				render_type_files($config, $dir, $files);
			} elseif ($action == "copy") {
				copy_files($config, $dir, $files);
			} else {
				error("Unknown action: " . $action);
			}
		}
	}
}

function lint_file($filename) {
	message(" ... verifying ...");

	exec("php -l $filename", $output, $ret);
	if ($ret != 0) {
		error("ERROR: The generated file: $filename is invalid.", FALSE);
		error($output);
	}
}

