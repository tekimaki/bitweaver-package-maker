{{foreach from=$config.services.functions key=func item=typemaps}}
function {{$config.name}}_{{$func}}( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
{{if $func eq 'content_load'}}
		{{* unknown need a model of behavior *}}
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == "one-to-one"}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
{{if $typemap.relation == "one-to-one"}}
		// Parse the {{$fieldName}}
		$parseHash['data'] = $pObject->mInfo['{{$fieldName}}'];
		$parseHash['cache_extension'] = "{{$typemapName}}_{{$fieldName}}";
		$pObject->mInfo['parsed_{{$fieldName}}'] = $pObject->parseData($parseHash);
{{/if}}
{{/if}}
{{/foreach}}
{{/if}}
{{/foreach}}
{{elseif $func eq 'upload_store'}}
{{if !empty($typemap.attachments)}}
{{foreach from=$typemap.attachments key=attachment item=prefs}}
		// Store the {{$attachment}} attachment
		if ( !empty($pParamHash['upload_store']['files']['{{$typemapName}}_{{$attachment}}']) ) {
			${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
			${{$config.name}}->store{{$attachment|ucfirst}}Attachment($pObject, $pParamHash['upload_store']['files']['{{$typemapName}}_{{$attachment}}']);
		}
{{/foreach}}
{{/if}}
{{elseif $func eq 'content_display'}}
		if( $pObject->isValid() ) {
			${{$config.name}} = new {{$config.class_name}}(); 
			$listHash = array( 'content_id' => $pObject->mContentId );
			$pObject->mInfo['{{$config.name}}'] = ${{$config.name}}->getList( $listHash );
		}
{{elseif $func eq 'content_list'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_list_history'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_preview'}}
		// call edit service which loads any data necessary for form
		{{$config.name}}_content_edit( $pObject, $pParamHash );
		// write form data on top of content hash
		${{$config.name}} = new {{$config.class_name}}(); 
		${{$config.name}}->previewTypemaps( $pParamHash );
		$pObject->mInfo['{{$config.name}}'] = $pParamHash['{{$config.name}}_store'];
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == "one-to-one"}}
		// Merge one-to-one typemap {{$typemapName}}
		if (!empty($pParamHash['{{$config.name}}_store']['{{$typemapName}}'] )) {
			$pObject->mInfo = array_merge( $pObject->mInfo, $pParamHash['{{$config.name}}_store']['{{$typemapName}}'] );
		}
{{/if}}
{{/foreach}}
{{elseif $func eq 'content_edit'}}
		global $gBitSmarty;
		// Prep any data we may need for the form
		// pass through to display to load up content data
		// {{$config.name}}_content_display( $pObject, $pParamHash );
{{assign var=jsColorIncluded value=false}}
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{foreach from=$typemap.fields key=fieldName item=field}}
{{* hexcolor lib *}}
{{if !empty($field.validator.type) && $field.validator.type == 'hexcolor' && !$jsColorIncluded}}
{{assign var=jsColorIncluded value=true}}
		// hexcolor library
		global $gBitThemes;
		$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/jscolor/jscolor.js', FALSE );
{{/if}}
{{* select options *}}
{{if $field.input.type == 'select'}}
{{if $field.input.source == 'dataset'}}
{{* @TODO - set up the pathing and class name in prepConfig so this is automatic from the dataset value *}}
{{if $field.input.dataset == 'usstates'}}
		require_once( UTIL_PKG_PATH.'datasets/regions/us/class.USStates.php' );
		${{$field.input.optionsHashName}} = USStates::getDataset(); 
		$gBitSmarty->assign_by_ref( '{{$field.input.optionsHashName}}', ${{$field.input.optionsHashName}} );
{{/if}}
{{/if}}
{{/if}}
{{/foreach}}
{{/foreach}}
{{elseif $func eq 'content_store'}}
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
		if( !${{$config.name}}->storeTypemaps( $pParamHash, FALSE ) ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
		}
{{elseif $func eq 'content_expunge'}}
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
		if( !${{$config.name}}->expungeTypemaps() ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
		}
{{elseif $func eq 'upload_expunge'}}
{{if !empty($typemap.attachments)}}
		// expunge the {{$attachment}} attachment
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId );
{{foreach from=$typemap.attachments key=attachment item=prefs}}
		${{$config.name}}->expunge{{$attachment|ucfirst}}Attachment( $pObject );
{{/foreach}}
{{/if}}
{{elseif $func eq 'content_load_sql'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = $ret['join_sql'] = $ret['where_sql'] = "";
{{foreach from=$typemaps item=typemap}}
{{if $config.typemaps.$typemap.relation eq 'one-to-one'}}
		$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.attachments key=attachment item=prefs name=attachments}}, {{$config.name}}_{{$typemap}}.`{{$typemap}}_{{$attachment}}_id`{{/foreach}} {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty_content"}}liberty_content{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."{{$config.name}}_{{$typemap}}` {{$config.name}}_{{$typemap}} {{if $config.typemaps.typemap.base_table == "liberty_content"}}liberty_content{{/if}} ON ( lc.`content_id`={{$config.name}}_{{$typemap}}.`content_id` )";
{{*		$ret['where_sql'] .= ""; *}}
{{/if}}
{{/foreach}}
		return $ret;
{{elseif $func eq 'content_list_sql'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = $ret['join_sql'] = $ret['where_sql'] = "";
{{foreach from=$typemaps item=typemap}}
{{if $config.typemaps.$typemap.relation eq 'one-to-one'}}
		$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.attachments key=attachment item=prefs name=attachments}}, {{$config.name}}_{{$typemap}}.`{{$typemap}}_{{$attachment}}_id`{{/foreach}} {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty"}}liberty_content{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."{{$config.name}}_{{$typemap}}` {{$config.name}}_{{$typemap}} {{if $config.typemaps.typemap.base_table == "liberty"}}liberty_content{{/if}} ON ( lc.`content_id`={{$config.name}}_{{$typemap}}.`content_id` )";
{{*		$ret['where_sql'] .= ""; *}}
{{/if}}
{{/foreach}}
{{*
        // return the values sent for pagination / url purposes
        $pParamHash['listInfo']['{{$config.name}}'] = $pParamHash['{{$config.name}}'];
        $pParamHash['listInfo']['ihash']['{{$config.name}}'] = $pParamHash['{{$config.name}}'];
*}}
		return $ret;
{{elseif $func eq 'comment_store'}}
		if( $pObject->isContentType( BITCOMMENT_CONTENT_TYPE_GUID ) ){
		{{* likely will be custom behavior *}}
		}
{{elseif $func eq 'content_admin'}}
{{elseif $func eq 'content_schema_inc'}}
{{/if}}
	}
}
{{/foreach}}
{{* section handlers *}}
{{if $config.sections}}
function {{$config.name}}_content_section( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
		// Check permissions on the section
		global $gBitUser;
		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
{{foreach from=$section.typemaps item=typemapName}}{{if $typemapName != 'liberty'}}
			$pObject->verifyUserPermission('p_{{$typemapName}}_service_view');
{{/if}}{{/foreach}}
			break;
{{/foreach}}
		}

		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
{{/foreach}}
			${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			$pObject->mInfo['{{$config.name}}']['{{$typemapName}}'] = ${{$config.name}}->get{{$typemapName|ucfirst}}ByContentId(); 
{{/foreach}}
			$pParamHash['has_section'] = TRUE;
			break;
		}
		/* =-=- CUSTOM BEGIN: content_section_function -=-= */
{{if !empty($customBlock.content_section_function)}}
{{$customBlock.content_section_function}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: content_section_function -=-= */
	}
}
{{/if}}

{{* admin settings handlers *}}
{{if $config.settings}}
function {{$config.name}}_package_admin( &$pParamHash ){
	include_once( CONFIG_PKG_PATH.'{{$package}}/plugins/{{$config.name}}/admin_plugin_inc.php' );
}
{{/if}}
