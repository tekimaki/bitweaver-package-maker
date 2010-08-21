{{foreach from=$config.services key=func item=typemaps}}
function {{$config.name}}_{{$func}}( $pObject, $pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
{{if $func eq 'content_load'}}
		{{* unknown need a model of behavior *}}
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
		$pObject->mInfo['{{$config.name}}'] = $pParamHash['{{$config.name}}'];
{{elseif $func eq 'content_edit'}}
		// pass through to display to load up content data
		{{$config.name}}_content_display( $pObject, $pParamHash );
{{elseif $func eq 'content_store'}}
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
		if( !${{$config.name}}->store( $pParamHash ) ){
			$pObject->setError( '{{$config.name}}', ${{$config.name}}->mErrors );
		}
{{elseif $func eq 'content_expunge'}}
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
		if( !${{$config.name}}->expunge() ){
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
