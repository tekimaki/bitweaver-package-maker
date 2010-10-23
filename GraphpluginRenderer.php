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

class GraphpluginRenderer extends PluginRenderer{
        public static function validateConfig( $config ) {
	        $vFile = 'graphplugin_validation.yaml';
		// @TODO figureout a way to spec this in the validation yaml file
		if( empty( $config['graph']['tail'] ) ){
			$errors['graph:tail'] = 'You must specify a tail content id relation';
		}
		if( empty( $config['graph']['head'] ) ){
			$errors['graph:head'] = 'You must specify a head content id relation';
		}
		aRenderer::validateConfigImpl( $config, $vFile, $errors );
	}

	public static function prepConfig( &$config ){ 
		// pass graphplugin value to plugin
		$config['plugin'] = $config['graphplugin'];

		parent::prepConfig( $config );
		/*
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
		 */

		// force base package
		$config['base_package'] = 'LibertyGraph'; 

		// force base class
		$config['base_class'] = 'LibertyEdge'; 

		// override plugin class
		$config['templates'] = array( 'PluginClass.php' => 'graph' );

		return $config;
	}

	public function generate( $config ){
		message("Generating plugin :".$config['graphplugin']);

		// Load the files we are to generate
		$gFiles = Spyc::YAMLLoad(RESOURCE_PATH.'plugin.yaml');

		// Locate all our templates.
		$this->locateTemplates();

		// Prepare any additional data based config data
		$this->prepConfig($config);

		// Initialize smarty
		$this->initSmarty($config);

		// Now change directory to CONFIG_PKG_PATH to generate the package in
		// the root of this install.
		chdir( CONFIG_PKG_PATH.$config['package'].'/plugins/' );

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
		$tmp_file = parent::convertName( $file, $config, $params );
		// set plugin Class name
		if( !empty( $config['class_name'] ) ){
			$tmp_file = preg_replace("/graph_PluginClass/", $config['class_name'], $tmp_file);
		}
		return $tmp_file;
	}
}
