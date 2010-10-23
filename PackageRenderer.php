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

        public static function validateConfig( $config ) {
	        // TODO: Refactor to use validateConfigImpl

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
	public static function prepConfig( &$config ){
		// Generate a few capitalization variations
		$config['package'] = strtolower($config['package']);
		$config['PACKAGE'] = strtoupper($config['package']);
		$config['Package'] = ucfirst(strtolower($config['package']));

		if( !empty( $config['types'] ) ){
			foreach ($config['types'] as $typeName => &$type) {
				$type['type_name'] = $typeName;
				TypeRenderer::prepConfig( $type );
			}
		}
		return $config;
	}

	public function generate( $config ){
		message("Generating package: ".$config['package']);

		// Load the files we are to generate
		$gFiles = Spyc::YAMLLoad(RESOURCE_PATH.'package.yaml');

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
					  	ServiceRenderer::prepConfig($config['services']);
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
		parent::initSmarty( $config );

		global $gBitSmarty;
		// Assign package in various cases to the context for
		// easier to read templates.
		$gBitSmarty->assign('package', $config['package']);
		$gBitSmarty->assign('PACKAGE', $config['PACKAGE']);
		$gBitSmarty->assign('Package', $config['Package']);

		// Assign the configuration to context
		$gBitSmarty->assign_by_ref('config', $config);
	}

	public function copyFiles($config, $dir, $files) {
		foreach ($files as $file) {
			$render_file = PackageRenderer::convertName($file, $config);
			$filename = $dir."/".$render_file;

			message(" ".$filename);

			if (!copy(RESOURCE_PATH.$file, $filename)) {
				error("Error copying file: $file");
			}
		}
	}

}
