{literal}<?php
/**
 * $Header: $
 *
 * Copyright (c) 2010 bitweaver.org
 * Copyright (c) 2010 nick palmer@overtsolutions.com
 *
 * All Rights Reserved. See below for details and a complete list of authors.
 * Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details
 *
 * $Id: $
 * @package {/literal}{$package}{literal}
 * @subpackage functions
 */

require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'Bit{/literal}{$Package}{literal}.php' );

$form{/literal}{$Package}{literal}Lists = array(
	"{/literal}{$package}{literal}_list_{/literal}{$package}{literal}_id" => array(
		'label' => 'Id',
		'note' => 'Display the {/literal}{$package}{literal} id.',
	),
	"{/literal}{$package}{literal}_list_title" => array(
		'label' => 'Title',
		'note' => 'Display the title.',
	),
	"{/literal}{$package}{literal}_list_description" => array(
		'label' => 'Description',
		'note' => 'Display the description.',
	),
	"{/literal}{$package}{literal}_list_data" => array(
		'label' => 'Text',
		'note' => 'Display the text.',
	),
);
$gBitSmarty->assign( 'form{/literal}{$Package}{literal}Lists', $form{/literal}{$Package}{literal}Lists );

// Process the form if we've made some changes
if( !empty( $_REQUEST['{/literal}{$package}{literal}_settings'] )) {
	${/literal}{$package}{literal}Toggles = array_merge( $form{/literal}{$Package}{literal}Lists );
	foreach( ${/literal}{$package}{literal}Toggles as $item => $data ) {
		simple_set_toggle( $item, {/literal}{$PACKAGE}{literal}_PKG_NAME );
	}
	simple_set_int( '{/literal}{$package}{literal}_home_id', {/literal}{$PACKAGE}{literal}_PKG_NAME );
}

// The list of {/literal}{$package}{literal} data is used to pick one to set the home
// we need to make sure that all {/literal}{$package}{literal} records are displayed
$_REQUEST['max_records'] = 0;

${/literal}{$package}{literal} = new Bit{/literal}{$Package}{literal}();
${/literal}{$package}{literal}_data = ${/literal}{$package}{literal}->getList( $_REQUEST );
$gBitSmarty->assign_by_ref( '{/literal}{$package}{literal}_data', ${/literal}{$package}{literal}_data);

${/literal}{$package}{literal}_home_id = $gBitSystem->getConfig( "{/literal}{$package}{literal}_home_id" );
$gBitSmarty->assign( '{/literal}{$package}{literal}_home_id', ${/literal}{$package}{literal}_home_id );
{/literal}