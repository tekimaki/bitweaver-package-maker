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

	public static function prepConfig( &$config ){ 
		$config['label'] = !empty( $typemap['label'] )?$typemap['label']:ucfirst($config['typemap']);

		// set default data relation
		$config['relation'] = !empty( $config['relation'] )?$config['relation']:'one-to-one';

		// set base_table
		$config['base_table'] = !empty( $config['base_table'] )?$config['base_table']:($config['base_package'] == 'liberty'?'liberty_content':NULL);

		// set relation requirements
		switch( $config['relation'] ){
		case 'one-to-one':
			if( $config['base_table'] == 'liberty_content' ) {
				if( empty( $config['fields']['content_id'] ) ){
					// keep content_id to the top of the stack
					$config['fields'] = array( 'content_id'=>array() )+$config['fields'];
				}
				$config['fields']['content_id']['schema']['primary'] = TRUE;
				$config['fields']['content_id']['validator']['type'] = 'int';
			}
			break;
		case 'one-to-many':
			if( $config['base_table'] == 'liberty_content' ) {
				if( empty( $config['fields']['content_id'] ) ){
					// keep content_id to the top of the stack
					$config['fields'] = array( 'content_id'=>array() )+$config['fields'];
				}
				$config['fields']['content_id']['validator']['type'] = 'int';
			}
			break;
		case 'many-to-many':
			break;
		}

		// set sequencing
		if( !empty( $config['attachments'] ) && $config['relation'] != 'one-to-one' ){
			$config['sequence'] = TRUE;
		}

		// prep fields
		TypemapRenderer::prepFieldsConfig( $config, $excludeFields ); // @TODO excludeFields ?
	}

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
						// @TODO this mess needs cleaning up look at tpls like plugin/edit/edit_section_inc.tpl.tpl 
						// difference of editing in a section or not 
						if( empty( $params['relation'] ) || $params['relation'] != 'one-to-many' ){
							// break;
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
