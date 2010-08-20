{{foreach from=$service.functions item=func}}
function {{$serviceName}}_{{$func}}( $pObject, $pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$serviceName|strtoupper}} ) ){
{{if $func eq 'content_load'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_display'}}
		if( $pObject->isValid() ) {
			${{$serviceName}} = new {{$service.class_name}}(); 
			$listHash = array( 'content_id' => $pObject->mContentId );
			$pObject->mInfo['{{$serviceName}}'] = ${{$serviceName}}->getList( $listHash );
		}
{{elseif $func eq 'content_list'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_list_history'}}
		{{* unknown need a model of behavior *}}
{{elseif $func eq 'content_preview'}}
		${{$serviceName}} = new {{$service.class_name}}(); 
		$pObject->mInfo['{{$serviceName}}'] = ${{$serviceName}}->previewFields( $pParamHash );
{{elseif $func eq 'content_edit'}}
		// pass through to display to load up content data
		{{$serviceName}}_content_display( $pObject, $pParamHash );
{{elseif $func eq 'content_store'}}
		${{$serviceName}} = new {{$service.class_name}}( $pObject->mContentId ); 
		if( !${{$serviceName}}->store( $pParamHash ) ){
			$pObject->setError( '{{$serviceName}}', ${{$serviceName}}->mErrors );
		}
{{elseif $func eq 'content_expunge'}}
		${{$serviceName}} = new {{$service.class_name}}( $pObject->mContentId ); 
		if( !${{$serviceName}}->expunge() ){
			$pObject->setError( '{{$serviceName}}', ${{$serviceName}}->mErrors );
		}
{{elseif $func eq 'content_load_sql'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = " {{foreach from=$service.fields key=fieldName item=field name=fields}},{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] = " LEFT JOIN `".BIT_DB_PREFIX."{{$serviceName}}` {{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}} ON ( lc.`content_id`={{$serviceName}}.`content_id` )";
		$ret['where_sql'] = "";
		return $ret;
{{elseif $func eq 'content_list_sql'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = " {{foreach from=$service.fields key=fieldName item=field name=fields}},{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] = " LEFT JOIN `".BIT_DB_PREFIX."{{$serviceName}}` {{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}} ON ( lc.`content_id`={{$serviceName}}.`content_id` )";
		$ret['where_sql'] = "";
{{*
        // return the values sent for pagination / url purposes
        $pParamHash['listInfo']['{{$serviceName}}'] = $pParamHash['{{$serviceName}}'];
        $pParamHash['listInfo']['ihash']['{{$serviceName}}'] = $pParamHash['{{$serviceName}}'];
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
