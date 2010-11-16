{{if ($service.relation == 'one-to-one' && !$typemap.service_prefs) 
	 || ($typemap.service_prefs.load && (in_array('content_display',$typemap.service_prefs.load) || in_array('content_load_sql',$typemap.service_prefs.load))) }}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = " {{foreach from=$service.fields key=fieldName item=field name=fields}},{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] = " LEFT JOIN `".BIT_DB_PREFIX."{{$serviceName}}` {{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}} ON ( lc.`content_id`={{$serviceName}}.`content_id` )";
		$ret['where_sql'] = "";
{{/if}}
{{assign var=functionName value=$serviceName|cat:_content_load_sql}}
		/* =-=- CUSTOM BEGIN: {{$functionName}} -=-= */
{{if !empty($customBlock.$functionName)}}
{{$customBlock.$functionName}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$functionName}} -=-= */

		return $ret;
