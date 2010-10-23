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
		aRenderer::prepFieldsConfig( $config, $excludeFields );

		return $config;
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
