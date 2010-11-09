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

	// Where is the root?
	$script_path = $_SERVER['PWD'] .'/'. $_SERVER["SCRIPT_FILENAME"];
	$root = preg_replace('|pkgmkr/generate\.php|', '', preg_replace('|/./|', '/', $script_path));

	// Some constants that we tend to use without thinking
	define("BIT_ROOT_PATH", $root);
	define("KERNEL_PKG_PATH", $root.'kernel/');
	define("CONFIG_PKG_PATH", $root.'config/');
	define("UTIL_PKG_PATH", $root.'util/');
	define("PKGMKR_PKG_PATH", $root.'pkgmkr/');

	// Define where we get some resources from.
	// Files to be copied will come from here.
	define("RESOURCE_PATH", PKGMKR_PKG_PATH . "resources/");

	// some convenient programming tools
	require_once( KERNEL_PKG_PATH.'kernel_lib.php' );
	// some convenient debugging tools
	require_once( KERNEL_PKG_PATH.'bit_error_inc.php' );

	// @TODO create autoloader for classes - this doesnt work with some of the nested static class references
	/* this just doesnt seem to work for nested classes or something
	if( !spl_autoload_functions() || !in_array( 'pkgmkr_autoloader', spl_autoload_functions() ) ) {
		function pkgmkr_autoloader($class) {
			$filePath =  './'.$class.'.php';
			if( file_exists( $filePath ) )
				require_once( $filePath );
		}
		spl_autoload_register('pkgmkr_autoloader');
	}
	*/
	require_once( PKGMKR_PKG_PATH . 'aRenderer.php' );
	require_once( PKGMKR_PKG_PATH . 'PackageRenderer.php' );
	require_once( PKGMKR_PKG_PATH . 'TypeRenderer.php' );
	require_once( PKGMKR_PKG_PATH . 'TypemapRenderer.php' );
	require_once( PKGMKR_PKG_PATH . 'ServiceRenderer.php' );
	require_once( PKGMKR_PKG_PATH . 'PluginRenderer.php' );
	require_once( PKGMKR_PKG_PATH . 'GraphpluginRenderer.php' );
	require_once( PKGMKR_PKG_PATH . 'SectionRenderer.php' );
}

function check_args($argv) {
	if (count($argv) != 2) {
		usage($argv);
	}
	$files = array($argv[1], BIT_ROOT_PATH.$argv[1].'/admin/pkg_'.$argv[1].'.yaml' );
	foreach ($files as $file) {
		if (is_file($file) && is_readable($file)) {
			echo "Loading $file\n";
			$yaml = Spyc::YAMLLoad($file);
			return $yaml;
		}
	}
	foreach ($files as $file) {
		error("Not a readable file: " .$file, false);
	}
	die;
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
				error( $key." is an invalid config type.", false);
				print_r($spec);
				error( "Aborting.", true);
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

