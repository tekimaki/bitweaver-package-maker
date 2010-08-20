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

class SectionRenderer extends aRenderer{
	public static function validateConfig( $config ){ 
		return FALSE;
	}

	public function prepConfig( &$config ){ 
		return $config;
	}

	public function generate( $config ){
		return FALSE;
	}

	public static function convertName( $file, $config, $params = array() ){
		$tmp_file = $file;
		if( !empty( $params['section'] ) ){
			$tmp_file = preg_replace("/section/", strtolower($params['section']), $tmp_file);
		}
		return $tmp_file; 
	}

	public static function renderFiles( $config, $dir, $files ){ 
		if( !empty( $config['sections'] ) ){
			foreach($config['sections'] as $section => $params) {
				global $gBitSmarty;
				$params['name'] = $params['section'] = $section;
				$gBitSmarty->assign('section', $params);
				foreach ($files as $file) {
					$render_file = PluginRenderer::convertName(SectionRenderer::convertName($file, $config, $params), NULL, $config);
					$template = $file.".tpl";
					$prefix = SectionRenderer::getTemplatePrefix($file, $params);
					// Render the file
					SectionRenderer::renderFile($dir, $render_file, $template, $config, $prefix);
				}
			}
		}
	}

}
