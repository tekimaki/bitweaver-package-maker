<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="bitpackage:pkgmkr/php_file_header.tpl"}}

// Initialization
require_once( '../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{{$package}}' );

require_once( {{$PACKAGE}}_PKG_PATH.'lookup_{{$type.name}}_inc.php' );

// Now check permissions to access this page
if( $gContent->isValid() ){
	$gContent->verifyUpdatePermission();
}else{
	$gContent->verifyCreatePermission();
}

// Check if the page has changed
if( !empty( $_REQUEST["save_{{$type.name}}"] ) ) {
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


// Prep any data we may need for the form
{{foreach from=$type.fields key=fieldName item=field}}
{{if $field.validator.type == 'reference' && $field.input.type == 'select'}}
${{$field.input.optionsHashName}} = $gContent->get{{$field.name|replace:" ":""}}Options();
${{$field.input.optionsHashName}}_list = array( ''=>tra('Select one...') );
foreach( ${{$field.input.optionsHashName}} as $key=>$value ){
	${{$field.input.optionsHashName}}_list[$key] = $value;
}
$gBitSmarty->assign_by_ref( '{{$field.input.optionsHashName}}', ${{$field.input.optionsHashName}}_list );
{{/if}}
{{/foreach}}


$gContent->invokeServices( 'content_edit_function' );


/* =-=- CUSTOM BEGIN: edit -=-= */
{{if !empty($customBlock.edit)}}
{{$customBlock.edit}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: edit -=-= */

// Include any javascript files we need for editing
{{strip}}
{{assign var=jsColorIncluded value=false}}
{{foreach from=$type.fields item=data key=field name=fields}}
	{{if !empty($data.validator.type) && $data.validator.type == 'hexcolor' && !$jsColorIncluded}}
		{{assign var=jsColorIncluded value=true}}
		$gBitThemes->loadJavascript( PKGMKR_PKG_PATH.'javascript/jscolor/jscolor.js', FALSE );
	{{/if}}
{{/foreach}}
{{if $type.js}}
	$gBitThemes->loadJavascript( {{$PACKAGE}}_PKG_PATH.'scripts/{{$type.class_name}}.js', TRUE );
{{/if}}
{{/strip}}


// Display the template
$gBitSystem->display( 'bitpackage:{{$package}}/edit_{{$type.name}}.tpl', tra('Edit {{$type.content_name|capitalize}}') , array( 'display_mode' => 'edit' ));


