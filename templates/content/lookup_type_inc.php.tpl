<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{include file="php_file_header.tpl"}}

global $gContent;
require_once( {{$PACKAGE}}_PKG_PATH.'{{$type.class_name}}.php');
//require_once( LIBERTY_PKG_PATH.'lookup_content_inc.php' );

// if we already have a gContent, we assume someone else created it for us, and has properly loaded everything up.
if( empty( $gContent ) || !is_object( $gContent ) || !$gContent->isValid() ) {
{{foreach from=$type.lookup_by key=lookup_by_key item=lookup_by name=lookup}}
	// if someone gives us a {{$lookup_by}} we try to find it
	if( !empty( $_REQUEST['{{$lookup_by}}'] ) ){
		global $gBitDb;
		$_REQUEST['{{$type.name}}_id'] = $gBitDb->getOne( "SELECT {{$type.name}}_id FROM `".BIT_DB_PREFIX."{{$type.name}}_data` {{$type.name|lower}} LEFT JOIN `".BIT_DB_PREFIX."liberty_content` lc ON ({{$type.name|lower}}.`content_id` = lc.`content_id`) WHERE {{$type.name|lower}}.`{{$lookup_by}}` = ?", array($_REQUEST['{{$lookup_by}}']) );
		if( empty( $_REQUEST['{{$type.name}}_id'] ) ) {
		  $gBitSystem->fatalError(tra('No {{$type.name}} found with the name: ').$_REQUEST['{{$lookup_by}}']);
		}
	}
{{/foreach}}

	// if {{$type.name}}_id supplied, use that
	if( @BitBase::verifyId( $_REQUEST['{{$type.name}}_id'] ) ) {
		$gContent = new {{$type.class_name}}( $_REQUEST['{{$type.name}}_id'] );

	// if content_id supplied, use that
	} elseif( @BitBase::verifyId( $_REQUEST['content_id'] ) ) {
		$gContent = new {{$type.class_name}}( NULL, $_REQUEST['content_id'] );

	} elseif (@BitBase::verifyId( $_REQUEST['{{$package}}']['{{$type.name}}_id'] ) ) {
		$gContent = new {{$type.class_name}}( $_REQUEST['{{$package}}']['{{$type.name}}_id'] );

	// otherwise create new object
	} else {
/* =-=- CUSTOM BEGIN: create -=-= */
{{if !empty($customBlock.create)}}
{{$customBlock.create}}
{{else}}
		$gContent = new {{$type.class_name}}();
{{/if}}
/* =-=- CUSTOM END: create -=-= */
	}

	$gContent->load();
	$gBitSmarty->assign_by_ref( "gContent", $gContent );
}

