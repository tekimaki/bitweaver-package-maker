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
		$parseHash['data'] = $data['{{$fieldName}}'];
		$parseHash['cache_extension'] = "{{$typemapName}}_{{$fieldName}}";
		$pObject->mInfo['parsed_{{$fieldName}}'] = $pObject->parseData($parseHash);
{{/if}}
{{/if}}
{{/foreach}}
{{/if}}
{{/foreach}}
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
		${{$config.name}} = new {{$config.class_name}}(); 
		${{$config.name}}->previewTypemaps( $pParamHash );
		$pObject->mInfo['{{$config.name}}'] = $pParamHash['{{$config.name}}_store'];
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == "one-to-one"}}
		// Merge one-to-one typemap {{$typemapName}}
		$pObject->mInfo = array_merge( $pParamHash['{{$config.name}}_store']['{{$typemapName}}'], $pObject->mInfo );
{{/if}}
{{/foreach}}
{{elseif $func eq 'content_edit'}}
		// pass through to display to load up content data
		{{$config.name}}_content_display( $pObject, $pParamHash );
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
{{elseif $func eq 'content_load_sql'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = $ret['join_sql'] = $ret['where_sql'] = "";
{{foreach from=$typemaps item=typemap}}
{{if $config.typemaps.$typemap.relation eq 'one-to-one'}}
		$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty_content"}}liberty_content{{/if}}.`{{$fieldName}}`{{/foreach}}";
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
		$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty"}}liberty_content{{/if}}.`{{$fieldName}}`{{/foreach}}";
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
