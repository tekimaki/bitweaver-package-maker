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
    public static function validateConfig( $config ) {
		$vFile = 'plugin_validation.yaml';
		parent::validateConfigImpl( $config, $vFile, $errors );
	}

	public static function prepConfig( &$config ){ 
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
			$config['base_package'] = 'liberty'; 

		// set default base class
		if( empty( $config['base_class'] ) )
			$config['base_class'] = 'LibertyBase'; 

		// prep typemap data 
		if( !empty( $config['typemaps'] ) ){
			foreach( $config['typemaps'] as $typemapName=>&$typemap ){
				$typemap['base_package'] = $config['base_package'];
				$typemap['typemap'] = $typemapName;
				TypemapRenderer::prepConfig( $typemap );
			}
			unset( $typemap ); // fucking php get it together - var is not scoped to the foreach!

			// prep sections so we know their typemaps
			if (!empty($config['sections'])) {
				foreach ($config['sections'] as &$section) {
					if (!empty($section['fields'])) {
						foreach ($section['fields'] as $map => $field) {
							$typemapName = array_keys($field);
							$section['typemaps'][$typemapName[0]] = $typemapName[0];
						}
					}
				}
			}

			// prep service-typemap association hash
			$services = Spyc::YAMLLoad(RESOURCE_PATH.'serviceapi.yaml');
			foreach( $config['typemaps'] as $typemapName=>&$typemap ){
				foreach( $services as $type=>$slist ){
					foreach( $slist as $func ){
						if( !empty( $typemap['services'] ) ){
							if( in_array( $func, $typemap['services'] ) || (!empty($typemap['services'][$type]) && in_array($func, $typemap['services'][$type])) ){
								$config['services'][$type][$func][] = $typemapName;
								$typemap['services'][$type][] = $func;
							}
						}
					}
				}
			}
			unset( $typemap ); // fu php

			// prep ajax
			foreach( $config['typemaps'] as $typemapName=>&$typemap ){
				if( !empty( $typemap['fields'] ) ){
					foreach( $typemap['fields'] as $field ){
						if( !empty( $field['input']['ajax'] ) ){
							$config['modifier'][] = 'ajax';
							break;
						}
					}
				}
			}
		}

		// prep section data
		if( !empty( $config['sections'] ) ){
			foreach( $config['sections'] as $sectionName=>&$section ){
				$section['name'] = $sectionName;
				SectionRenderer::prepConfig( $section );
			}
			unset( $section );
		}

		return $config;
	}

	public function generate( $config ){
		message("Generating plugin :".$config['plugin']);

		$plugin_path = CONFIG_PKG_PATH.$config['package'].'/plugins/';

		// Load the files we are to generate
		$gFiles = Spyc::YAMLLoad(RESOURCE_PATH.'plugin.yaml');

		// Locate all our templates.
		$this->locateTemplates();

		// Prepare any additional data based config data
		$this->prepConfig($config);

		// Initialize smarty
		$this->initSmarty($config);

		// Now figure out the real directory and file names
		foreach ($gFiles as $file_dir => $actions) {
			$dir = $this->convertName($file_dir, NULL, $config);
			$dir_path = $plugin_path.$dir;

			// Does the directory exist
			if (!is_dir($dir_path)) {
				echo " ".$dir_path."\n";
				// if (!mkdir($dir)) {
				if( !mkdir( $dir_path, 0755, TRUE ) ){
					error("Could not create directory!");
				}
			}

			// Now change directory to CONFIG_PKG_PATH to generate the package in
			// the root of this install.
			chdir( $plugin_path );

			// @TODO This switch is annoying, cant we automatically know the renderer based on the action
			foreach ($actions as $action => $files) {
				switch( $action ){
				case "plugin":
					$this->renderFiles($config, $dir, $files);
					break;
				case "typemap":
					TypemapRenderer::renderFiles($config, $dir, $files );
					break;
				case "section":
					SectionRenderer::renderFiles($config, $dir, $files );
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
		// rename plugin_schema_inc file to schema_inc
		$tmp_file = preg_replace("/schema_plugin/", "schema", $tmp_file);
		// swop plugin as keyword
		if( !empty( $params['plugin'] ) ){
			$tmp_file = preg_replace("/plugin/", strtolower($params['plugin']), $tmp_file);
		}
		// set plugin Class name
		if( !empty( $config['class_name'] ) ){
			$tmp_file = preg_replace("/PluginClass/", $config['class_name'], $tmp_file);
		}
		return $tmp_file;
	}

	public static function renderFiles( $config, $dir, $files ){ 
		foreach ($files as $file) {
			$render = TRUE;
			// optional files
			switch( $file ){
			case 'service_edit_mini_inc.tpl':
				$render = FALSE;
				if( !empty( $config['services']['templates'] ) ){
					$render = in_array( 'content_edit_mini', array_keys($config['services']['templates']) );
				}
				break;
			case 'service_edit_tab_inc.tpl':
				$render = FALSE;
				if( !empty( $config['services']['templates'] ) ){
					$render = in_array( 'content_edit_tab', array_keys($config['services']['templates']) );
				}
				break;
			case 'admin_plugin_inc.php':
			case 'service_admin_inc.tpl':
			case 'menu_plugin_admin_inc.tpl':
				$render = !empty( $config['settings'] );
				break;
			case 'plugin_ajax.php':
			case 'plugin_ajax.tpl':
			case 'PluginClass.js':
				$render = !empty( $config['modifier'] ) && in_array( 'ajax', $config['modifier'] )?TRUE:FALSE;
				break;
			default:
				break;
			}
			// render
			if( $render ){
				$render_file = self::convertName($file, $config);
				$template = $file.".tpl";
				$prefix = self::getTemplatePrefix($file, $config);
				// Render the file
				self::renderFile($dir, $render_file, $template, $config, $prefix);
			}
		}
	}

	protected function initSmarty( &$config ){ 
		global $gBitSmarty;

		parent::initSmarty( $config );

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
