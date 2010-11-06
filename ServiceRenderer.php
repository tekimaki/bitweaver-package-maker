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

class ServiceRenderer extends aRenderer{

	public static function prepConfig( &$config ) {
		$excludeFields = array( 'title', 'data', 'summary' );			// yaml may specify settings for auto generated fields in the field list, so we exclude them from requirements checks
		foreach ($config as $serviceName => $service) {
			// prep form fields
			aRenderer::prepFieldsConfig( $config[$serviceName], $excludeFields );
		}
		return $config;
	}

	public static function convertName( $file, $config, $params = array() ){
		$tmp_file = preg_replace("/service/", strtolower($params['service']), $file);
		return preg_replace("/ServiceClass/", $params['class_name'], $tmp_file);
	}

	public static function renderFiles( $config, $dir, $files ){ 
		if( !empty( $config['services'] ) ){
			foreach($config['services'] as $service => $params) {
				global $gBitSmarty;
				$params['name'] = $service;
				$gBitSmarty->assign('service', $params);
				$gBitSmarty->assign('serviceName', $service);
				foreach ($files as $file) {				  
					$render_file = PackageRenderer::convertName(ServiceRenderer::convertName($file, $service, $params), $config);
					$template = $file.".tpl";
					$prefix = ServiceRenderer::getTemplatePrefix($file, $params);
					// Render the file
					ServiceRenderer::renderFile($dir, $render_file, $template, $config, $prefix);
				}
			}
		}
	}
}
