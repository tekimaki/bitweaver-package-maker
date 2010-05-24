{literal}<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{/literal}{include file="bitpackage:pkgmkr/php_file_header.tpl"}{literal}

// Initialization
require_once( '../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{/literal}{$package}{literal}' );

$typeIds = array({/literal}
{foreach from=$config.types key=typeName item=type name=types}
		"{$typeName}_id"{if !$smarty.foreach.types.last},{/if}
{/foreach}{literal}
	);

// if a content type key id is requested load it up
$requestType = NULL;
foreach( $_REQUEST as $key => $val ) {
	if (in_array($key, $typeIds)) {
		$requestType = substr($key, 0, -3);
		break;
	}
}

{/literal}{if $config.homeable}{literal}
if (empty($requestType)) {
	// Use the home type and home content
	$requestType = $gBitSystem->getConfig("{/literal}{$package}_home_type", "{foreach from=$config.types key=typeName item=type name=types}{if $smarty.foreach.types.first}{$typeName}{/if}{/foreach}{literal}");
	$_REQUEST[$requestType.'_id'] = $gBitSystem->getConfig( "{/literal}{$package}{literal}_".$requestType."_home_id" );
}
{/literal}{/if}{literal}

// If there is an id to get, specified or default, then attempt to get it and display
if( !empty( $_REQUEST[$requestType.'_id'] ) ) {
	// Look up the content
	require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_'.$requestType.'_inc.php' );

	if( !$gContent->isValid() ) {
		// Check permissions to access this content in general
		$gContent->verifyViewPermission();

		// They are allowed to see that this does not exist.
		$gBitSystem->setHttpStatus( 404 );
		$gBitSystem->fatalError( tra( "The requested ".$gContent->getContentTypeName()." (id=".$_REQUEST[$requestType.'_id'].") could not be found." ) );
	}

	// Now check permissions to access this content
	$gContent->verifyViewPermission();

	// Add a hit to the counter
	$gContent->addHit();

	// Display the template
	$gBitSystem->display( 'bitpackage:{/literal}{$package}{literal}/display_'.$requestType.'.tpl', htmlentities($gContent->getField('title', '{/literal}{$Package}{literal} '.ucfirst($requestType))) , array( 'display_mode' => 'display' ));

{/literal}{if $config.homeable}{literal}
} else if ( $gBitUser->hasPermission( 'p_{/literal}{$package}{literal}_admin' ) ) {
    // Redirect to set up the default {/literal}{$package}{literal} data to display
	header( "Location: ".KERNEL_PKG_URL.'admin/index.php?page='.{/literal}{$PACKAGE}{literal}_PKG_NAME );

} else {
	$gBitSystem->setHttpStatus( 404 );
	$gBitSystem->fatalError( tra( "The default {/literal}{$package}{literal} page has not been configured." ) );
}
{/literal}{else}{literal}
}else{
{/literal}
	/* =-=- CUSTOM BEGIN: index -=-= */
{if !empty($customBlock.index)}
{$customBlock.index}
{else}
		$indexTitle = tra('{$Package}');
		$gBitSmarty->assign( 'indexTitle', $indexTitle );
		$gBitSystem->display( 'bitpackage:{$config.package}/display_index.tpl', $indexTitle, array( 'display_mode' => 'display' ));
{/if}
	/* =-=- CUSTOM END: index -=-= */
{literal}
}
{/literal}{/if}

