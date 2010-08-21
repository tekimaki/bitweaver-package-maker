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

class PluginRenderer extends aRenderer{
	public static function validateConfig( $config ){ 
		// todo 
	}

	public function prepConfig( &$config ){ 
		// Generate a few capitalization variations
		$config['plugin'] = $config['name'] = strtolower($config['plugin']);
		$config['PLUGIN'] = strtoupper($config['plugin']);
		$config['Plugin'] = ucfirst(strtolower($config['plugin']));
		$config['package'] = strtolower($config['package']);
		$config['PACKAGE'] = strtoupper($config['package']);
		$config['Package'] = ucfirst(strtolower($config['package']));

		// set default class name
		if( empty( $config['class_name'] ) )
			$config['class_name'] = ucfirst( $config['plugin'] ).'Plugin'; 

		// set default base package
		if( empty( $config['base_package'] ) )
			$config['base_package'] = 'Liberty'; 

		// set default base package
		if( empty( $config['base_class'] ) )
			$config['base_class'] = 'LibertyBase'; 

		// set default base class
		return $config;
	}

	public function generate( $config ){
		message("Generating plugin :".$config['plugin']);

		// Load the files we are to generate
		$gFiles = Spyc::YAMLLoad(RESOURCE_DIR.'plugin.yaml');

		// Now change directory to CONFIG_PKG_PATH to generate the package in
		// the root of this install.
		chdir( CONFIG_PKG_PATH.$config['package'].'/plugins/' );

		// Locate all our templates.
		$this->locateTemplates();

		// Prepare any additional data based config data
		$this->prepConfig($config);

		// Initialize smarty
		$this->initSmarty($config);

		// Now figure out the real directory and file names
		foreach ($gFiles as $file_dir => $actions) {
			$dir = $this->convertName($file_dir, NULL, $config);

			// Does the directory exist
			if (!is_dir($dir)) {
				echo " ".$dir."\n";
				if (!mkdir($dir)) {
					error("Could not create directory!");
				}
			}

			foreach ($actions as $action => $files) {
				switch( $action ){
				case "plugin":
					$this->renderFiles($config, $dir, $files);
					break;
				case "section":
					if ( !empty( $config['sections'] ) ) {
						SectionRenderer::renderFiles($config, $dir, $files );
					}
					break;
				default:
					error("Unknown action: " . $action);
					break;
				}
			}
		}
	}


	public static function convertName( $file, $config, $params = array() ){
		$tmp_file = $file;
		if( !empty( $params['plugin'] ) ){
			$tmp_file = preg_replace("/plugin/", strtolower($params['plugin']), $tmp_file);
		}
		if( !empty( $config['class_name'] ) ){
			$tmp_file = preg_replace("/PluginClass/", $config['class_name'], $tmp_file);
		}
		return $tmp_file; //preg_replace("/PluginClass/", $params['class_name'], $tmp_file);
	}

	public static function renderFiles( $config, $dir, $files ){ 
		foreach ($files as $file) {
			$render_file = PluginRenderer::convertName($file, $config);
			$template = $file.".tpl";
			$prefix = PluginRenderer::getTemplatePrefix($file, $config);
			// Render the file
			PluginRenderer::renderFile($dir, $render_file, $template, $config, $prefix);
		}
	}

	protected function initSmarty( &$config ){ 
		parent::initSmarty();

		global $gBitSmarty;
		// Assign package in various cases to the context for
		// easier to read templates.
		$gBitSmarty->assign('plugin', $config['plugin']);
		$gBitSmarty->assign('PLUGIN', $config['PLUGIN']);
		$gBitSmarty->assign('Plugin', $config['Plugin']);
		$gBitSmarty->assign('package', $config['package']);
		$gBitSmarty->assign('PACKAGE', $config['PACKAGE']);
		$gBitSmarty->assign('Package', $config['Package']);

		// Assign the configuration to context
		$gBitSmarty->assign('config', $config);
	}
}
