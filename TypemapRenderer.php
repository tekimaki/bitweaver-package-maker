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

class TypemapRenderer extends aRenderer{

	public static function convertName( $file, $config, $params = array() ){
		$tmp_file = $file;
		if( !empty( $params['typemap'] ) ){
			$tmp_file = preg_replace("/typemap/", strtolower($params['typemap']), $tmp_file);
		}
		return $tmp_file; 
	}

	public static function renderFiles( $config, $dir, $files ){ 
		if( !empty( $config['typemaps'] ) ){
			foreach($config['typemaps'] as $typemap => $params) {
				foreach ($files as $file) {
					switch( $file ){
					case 'fieldset_typemap_inc.tpl':
						// if not one-to-many do not render this tpl
						if( empty( $params['relation'] ) || $params['relation'] != 'one-to-many' ){
							break;
						}
					default: 
						global $gBitSmarty;
						$params['typemap'] = $typemap;
						$gBitSmarty->assign('typemapName', $typemap);
						$gBitSmarty->assign('typemap', $params);
						self::renderTypemapFile( $config, $dir, $file, $params );
						break;
					}
				}
			}
		}
	}

	public static function renderTypemapFile( $config, $dir, $file, $params = array() ){
		$render_file = PluginRenderer::convertName(TypemapRenderer::convertName($file, $config, $params), NULL, $config);
		$template = $file.".tpl";
		$prefix = TypemapRenderer::getTemplatePrefix($file, $params);
		// Render the file
		parent::renderFile($dir, $render_file, $template, $config, $prefix);
	}

}
