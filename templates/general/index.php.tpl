<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
{{* no types redirect home *}}
{{if !$config.types}}
   header ("location: ../index.php");
{{* if types *}}
{{elseif $config.types}}
{{include file="php_file_header.tpl"}}

// Initialization
require_once( '../kernel/setup_inc.php' );

// Is package installed and enabled
$gBitSystem->verifyPackage( '{{$package}}' );

/* =-=- CUSTOM BEGIN: security -=-= */
{{if !empty($customBlock.security)}}
{{$customBlock.security}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: security -=-= */

// Define content lookup keys
$typeNames = array(
{{foreach from=$config.types key=typeName item=type name=types}}
{{if $type.lookup_by && in_array('title',$type.lookup_by)}}
		"{{$typeName}}_name"{{if !$smarty.foreach.types.last}},{{/if}}
{{/if}}
{{/foreach}}
	);
$typeIds = array(
{{foreach from=$config.types key=typeName item=type name=types}}
		"{{$typeName}}_id"{{if !$smarty.foreach.types.last}},{{/if}}
{{/foreach}}
	);
$typeContentIds = array(
{{foreach from=$config.types key=typeName item=type name=types}}
		"{{$typeName}}_content_id"{{if !$smarty.foreach.types.last}},{{/if}}
{{/foreach}}
	);

// If a content type key id is requested load it up
$requestType = NULL;
$requestKeyType = NULL;
foreach( $_REQUEST as $key => $val ) {
    if (in_array($key, $typeNames)) {
        $requestType = substr($key, 0, -5);
        $requestKeyType = 'name';
        break;
    }
    elseif (in_array($key, $typeIds)) {
        $requestType = substr($key, 0, -3);
        $requestKeyType = 'id';
        break;
    }
    elseif (in_array($key, $typeContentIds)) {
        $requestType = substr($key, 0, -11);
        $requestKeyType = 'content_id';
        break;
    }
}

{{if $config.homeable}}
if (empty($requestType)) {
	// Use the home type and home content
	$requestType = $gBitSystem->getConfig("{{$package}}_home_type", "{{foreach from=$config.types key=typeName item=type name=types}}{{if $smarty.foreach.types.first}}{{$typeName}}{{/if}}{{/foreach}}");
    if( $gBitSystem->getConfig( '{{$package}}_home_format', 'list' ) == 'list' ){
        include_once( {{$PACKAGE}}_PKG_PATH.'list_'.$requestType.'.php' );
        die;
    }else{
		$_REQUEST[$requestType.'_id'] = $gBitSystem->getConfig( "{{$package}}_".$requestType."_home_id" );
	}
}
{{/if}}

// If there is an id to get, specified or default, then attempt to get it and display
if( !empty( $_REQUEST[$requestType.'_name'] ) ||
    !empty( $_REQUEST[$requestType.'_id'] ) ||
    !empty( $_REQUEST[$requestType.'_content_id'] ) ) {
	// Look up the content
	require_once( {{$PACKAGE}}_PKG_PATH.'lookup_'.$requestType.'_inc.php' );

	if( !$gContent->isValid() ) {
		// Check permissions to access this content in general
		$gContent->verifyViewPermission();

		// They are allowed to see that this does not exist.
		$gBitSystem->setHttpStatus( 404 );
		$gBitSystem->fatalError( tra( "The requested ".$gContent->getContentTypeName()." (id=".$_REQUEST[$requestType.'_id'].") could not be found." ) );
	}

	// Now check permissions to access this content
	$gContent->verifyViewPermission();

	{{if $config.pluggable}}
	// If package plugin section is specified invoke the related service - it is responsible for displaying the section
	if( !empty( $_REQUEST['section'] ) ){
		// Someone is trying an attack - piss off
		if (preg_match("/[a-z_]/", $_REQUEST['section']) != 1) { 
			$gBitSystem->fatalError( tra('nice try') );
		}else{
			$sectionHash = $_REQUEST;
			$gContent->invokeServices( 'content_section_function', $sectionHash );
			if( empty( $sectionHash['has_section'] ) ){
				$gBitSystem->fatalError( tra('unknown section' ) );
			}

			// Display the plugin template
			$gBitSystem->display( 'bitpackage:liberty/service_content_display_section.tpl', htmlentities($gContent->getField('title', '{{$Package}} '.ucfirst($_REQUEST['section']))) , array( 'display_mode' => 'display' ));
			die;
		}
	}
	{{/if}}

	// Call display services
	$displayHash = array( 'perm_name' => $gContent->mViewContentPerm );
	$gContent->invokeServices( 'content_display_function', $displayHash );

	// Add a hit to the counter
	$gContent->addHit();

	/* =-=- CUSTOM BEGIN: indexload -=-= */
{{if !empty($customBlock.indexload)}}
{{$customBlock.indexload}}
{{/if}}
	/* =-=- CUSTOM END: indexload -=-= */

	// Display the template
	$gBitSystem->display( 'bitpackage:{{$package}}/display_'.$requestType.'.tpl', htmlentities($gContent->getField('title', '{{$Package}} '.ucfirst($requestType))) , array( 'display_mode' => 'display' ));

{{if $config.homeable}}
} else if ( $gBitUser->hasPermission( 'p_{{$package}}_admin' ) ) {
    // Redirect to set up the default {{$package}} data to display
	header( "Location: ".KERNEL_PKG_URL.'admin/index.php?page='.{{$PACKAGE}}_PKG_NAME );

} else {
	$gBitSystem->setHttpStatus( 404 );
	$gBitSystem->fatalError( tra( "The default {{$package}} page has not been configured." ) );
}
{{else}}
}else{

	/* =-=- CUSTOM BEGIN: index -=-= */
{{if !empty($customBlock.index)}}
{{$customBlock.index}}
{{else}}
		$indexTitle = tra('{{$Package}}');
		$gBitSmarty->assign( 'indexTitle', $indexTitle );
		$gBitSystem->display( 'bitpackage:{{$config.package}}/display_index.tpl', $indexTitle, array( 'display_mode' => 'display' ));
{{/if}}
	/* =-=- CUSTOM END: index -=-= */

}
{{/if}}
{{/if}}
{{* end type index block *}}

