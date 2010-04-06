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

global $gContent;
require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'{/literal}{$type.class_name}{literal}.php');
require_once( LIBERTY_PKG_PATH.'lookup_content_inc.php' );

// if we already have a gContent, we assume someone else created it for us, and has properly loaded everything up.
if( empty( $gContent ) || !is_object( $gContent ) || !$gContent->isValid() ) {
	// if {/literal}{$type.name}{literal}_id supplied, use that
	if( @BitBase::verifyId( $_REQUEST['{/literal}{$type.name}{literal}_id'] ) ) {
		$gContent = new {/literal}{$type.class_name}{literal}( $_REQUEST['{/literal}{$type.name}{literal}_id'] );

	// if content_id supplied, use that
	} elseif( @BitBase::verifyId( $_REQUEST['content_id'] ) ) {
		$gContent = new {/literal}{$type.class_name}{literal}( NULL, $_REQUEST['content_id'] );

	} elseif (@BitBase::verifyId( $_REQUEST['{/literal}{$package}{literal}']['{/literal}{$type.name}{literal}_id'] ) ) {
		$gContent = new {/literal}{$type.class_name}{literal}( $_REQUEST['{/literal}{$package}{literal}']['{/literal}{$type.name}{literal}_id'] );

	// otherwise create new object
	} else {
		$gContent = new {/literal}{$type.class_name}{literal}();
	}

	$gContent->load();
	$gBitSmarty->assign_by_ref( "gContent", $gContent );
}
{/literal}