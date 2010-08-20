<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
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


function pkgmkr_setup() {
	// Avoid anoying errors about timezone
	ini_set('date.timezone', 'GMT');

	// Define where we get some resources from.
	// Files to be copied will come from here.
	define("RESOURCE_DIR", "resources/");

	// Where is the root?
	$script_path = $_SERVER['PWD'] .'/'. $_SERVER["SCRIPT_FILENAME"];
	$root = preg_replace('|pkgmkr/generate\.php|', '', preg_replace('|/./|', '/', $script_path));

	// Some constants that we tend to use without thinking
	define("BIT_ROOT_PATH", $root);
	define("KERNEL_PKG_PATH", $root.'/kernel/');
	define("CONFIG_PKG_PATH", $root.'/config/');
	define("UTIL_PKG_PATH", $root.'/util/');
	define("PKGMKR_PKG_PATH", $root.'/pkgmkr/');

	// some convenient debugging tools
	require_once( KERNEL_PKG_PATH.'bit_error_inc.php' );

	// create autoloader for classes
	if( !spl_autoload_functions() || !in_array( 'pkgmkr_autoloader', spl_autoload_functions() ) ) {
		function pkgmkr_autoloader($class) {
			$filePath =  './'.$class.'.php';
			if( file_exists( $filePath ) )
				require_once( $filePath );
		}
		spl_autoload_register('pkgmkr_autoloader');
	}
	// for some reason getting an error when trying to autoload this class
	// PHP Fatal error:  Class 'TypeRenderer' not found in /home/consulting/live/clients/bwpro/pkgmkr/PackageRenderer.php on line 180
	require_once( './TypeRenderer.php' );
}

function check_args($argv) {
	if (count($argv) != 2) {
		usage($argv);
	}
	if (is_file($argv[1])) {
		$yaml = Spyc::YAMLLoad($argv[1]);
		return $yaml;
	}
	error("Not a readable file: " .$argv[1]);
}

function generate( $spec ){
	if( !is_array( $spec ) ){
		error("Nothing to render - please check your yaml specification file.");
	}else{
		// validate the entire spec file first
		foreach( $spec as $key=>$config ){
			$baseClass = 'aRenderer';
			$targetClass = ucfirst($key).'Renderer';
			if (!class_exists($targetClass) || !is_subclass_of($targetClass, $baseClass)){
				error( $key." is an invalid config type.");
			}
			$Renderer = new $targetClass;
			$Renderer->validateConfig($config);
		}
		// process each config in the file
		foreach( $spec as $key=>$config ){
			$baseClass = 'aRenderer';
			$targetClass = ucfirst($key).'Renderer';
			if (class_exists($targetClass) && is_subclass_of($targetClass, $baseClass))
				$Renderer = new $targetClass;
			else
				throw new Exception("The renderer type '$key' is not recognized.");

			$Renderer->generate( $config );
		}
	}
}

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

// {{{ =================== Service Mthods  ====================

function convert_servicename($file, $service, $className){
	$tmp_file = preg_replace("/service/", strtolower($service), $file);
	return preg_replace("/ServiceClass/", $className, $tmp_file);
}

function render_service_files($config, $dir, $files) {
	if( !empty( $config['services'] ) ){
		foreach($config['services'] as $service => $params) {
			global $gBitSmarty;
			$params['name'] = $service;
			$gBitSmarty->assign('service', $params);
			foreach ($files as $file) {
				$pkg_file = PackageRenderer::convertName(convert_servicename($file, $service, $params), $config);
				$template = $file.".tpl";
				$prefix = PackageRenderer::getTemplatePrefix($file, $params);
				// Render the file
				PackageRenderer::renderFile($dir, $pkg_file, $template, $config, $prefix);
			}
		}
	}
}

// }}} -- end of Service Methods
