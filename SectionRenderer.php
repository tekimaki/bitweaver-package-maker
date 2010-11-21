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

	/**
	 * prepConfig
	 * @param $config - a section hash
	 */
	public static function prepConfig( &$config ){
		// compile a list of typemaps the section references for its view  
		if( !empty( $config['bodyfields'] ) ){
			$config['view_typemaps'] = array(); 
			foreach( $config['bodyfields'] as $fields ){
				foreach( $fields as $typemapName => $field ){
					if( !in_array( $typemapName, $config['view_typemaps'] ) ){
						array_push( $config['view_typemaps'], $typemapName );
					}
				}
			}
		}
	}

	public static function convertName( $file, $config, $params = array() ){
		$tmp_file = $file;
		if( !empty( $params['section'] ) ){
			$tmp_file = preg_replace("/section_inc/", strtolower($params['section']).'_inc', $tmp_file);
		}
		return $tmp_file; 
	}

	public static function renderFiles( $config, $dir, $files ){ 
		if( !empty( $config['sections'] ) ){
			foreach ($files as $file) {
				switch( $file ){
				// each of these files is customized per section
				case 'display_section_inc.tpl':
					foreach($config['sections'] as $section => $params) {
						global $gBitSmarty;
						if( empty( $params['modes'] ) || in_array( 'view', $params['modes'] ) ){
							$params['name'] = $params['section'] = $section;
							$gBitSmarty->assign('section', $params);
							SectionRenderer::renderSectionFile( $config, $dir, $file, $params );
						}
					}
					break;
				case 'edit_sect_section_inc.tpl':
					foreach($config['sections'] as $section => $params) {
						global $gBitSmarty;
						if( !empty( $params['modes'] ) && in_array( 'edit', $params['modes'] ) ){
							$params['name'] = $params['section'] = $section;
							$gBitSmarty->assign('section', $params);
							$gBitSmarty->assign('section', $params);
							SectionRenderer::renderSectionFile( $config, $dir, $file, $params );
						}
					}
					break;
				// common section files
				default:
					SectionRenderer::renderSectionFile( $config, $dir, $file );
					break;
				}
			}
		}
	}

	public static function renderSectionFile( $config, $dir, $file, $params = array() ){
		$render_file = PluginRenderer::convertName(SectionRenderer::convertName($file, $config, $params), NULL, $config);
		$template = $file.".tpl";
		$prefix = SectionRenderer::getTemplatePrefix($file, $params);
		// Render the file
		parent::renderFile($dir, $render_file, $template, $config, $prefix);
	}

}
