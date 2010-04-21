{literal}<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{/literal}{include file="bitpackage:pkgmkr/php_file_header.tpl"}{literal}

// Initialization
require_once( '../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{/literal}{$package}{literal}' );

require_once( {/literal}{$PACKAGE}{literal}_PKG_PATH.'lookup_{/literal}{$type.name}{literal}_inc.php' );

// Now check permissions to access this page
if( $gContent->isValid() ){
	$gContent->verifyUpdatePermission();
}else{
	$gContent->verifyCreatePermission();
}

// Check if the page has changed
if( !empty( $_REQUEST["save_{/literal}{$type.name}{literal}"] ) ) {
	// Editing requires general ticket verification
	$gBitUser->verifyTicket();

	if( $gContent->store( $_REQUEST ) ) {
		bit_redirect( $gContent->getDisplayUrl() );
	} else {
		// if store fails set preview
		$_REQUEST['preview'] = TRUE;
		// And put all the variables into the object
		$gContent->preparePreview( $_REQUEST );
		$gBitSmarty->assign_by_ref( 'errors', $gContent->mErrors );
	}
}

// If we are in preview mode then preview it!
if( isset( $_REQUEST["preview"] ) ) {
	// Run verify so they see any errors with their preview
	$gContent->verify( $_REQUEST );
	// Put all the variables into the object
	$gContent->preparePreview( $_REQUEST );
	$gContent->invokeServices( 'content_preview_function' );
	$gBitSmarty->assign( 'preview', TRUE );
} else {
	$gContent->invokeServices( 'content_edit_function' );
}

{/literal}
// Prep any data we may need for the form
{foreach from=$type.fields key=fieldName item=field}
{if $field.validator.input == 'select'}
${$field.validator.optionsHashName} = $gBitSystem->mDb->getAssoc("{$field.validator.optionsHashQuery}");
$gBitSmarty->assign_by_ref( '{$field.validator.optionsHashName}', ${$field.validator.optionsHashName} );
{/if}
{/foreach}
{literal}

{/literal}
// Include any javascript files we need for editing
{strip}
{assign var=jsColorIncluded value=false}
{foreach from=$type.fields item=data key=field name=fields}
	{if !empty($data.validator.type) && $data.validator.type == 'hexcolor' && !$jsColorIncluded}
		{assign var=jsColorIncluded value=true}
		{literal}$gBitThemes->loadJavascript( PKGMKR_PKG_PATH.'javaacript/jscolor/jscolor.js', FALSE );{/literal}
	{/if}
{/foreach}
{/strip}
{literal}

// Display the template
$gBitSystem->display( 'bitpackage:{/literal}{$package}{literal}/edit_{/literal}{$type.name}{literal}.tpl', tra('Edit {/literal}{$type.name|capitalize}{literal}') , array( 'display_mode' => 'edit' ));

{/literal}
