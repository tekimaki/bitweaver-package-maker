{{if $service.relation == 'one-to-one'}}
		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = $ret['join_sql'] = $ret['where_sql'] = "";
{{* load all the time *}}
{{if !$service.service_prefs 
	 || ($service.service_prefs.load && (in_array('content_display',$service.service_prefs.load) || in_array('content_load_sql',$service.service_prefs.load)))
}}
		$ret['select_sql'] .= " {{foreach from=$service.fields key=fieldName item=field name=fields}},{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}.`{{$fieldName}}`{{/foreach}}";
		$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."{{$serviceName}}` {{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}} ON ( lc.`content_id`={{$serviceName}}.`content_id` )";
{*		$ret['where_sql'][] = ""; *}
{{* load only in the case of a section request *}}
{{elseif $config.sections
	 && ($service.service_prefs.load && in_array('content_section',$service.service_prefs.load))	
}}
		if( !empty( $pParamHash['section'] ) ){
			switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
{{if ($section.view_typemaps && in_array($serviceName,$section.view_typemaps))||($section.typemaps && in_array($serviceName,$section.typemaps)) }}
			case '{{$sectionName}}':
				$ret['select_sql'] = " {{foreach from=$service.fields key=fieldName item=field name=fields}},{{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}}.`{{$fieldName}}`{{/foreach}}";
				$ret['join_sql'] = " LEFT JOIN `".BIT_DB_PREFIX."{{$serviceName}}` {{$serviceName}}{{if $service.base_package == "liberty"}}_data{{/if}} ON ( lc.`content_id`={{$serviceName}}.`content_id` )";
{*				$ret['where_sql'][] = ""; *}
				break;
{{/if}}
{{/foreach}}
			}
		}
{{/if}}
{{assign var=functionName value=$serviceName|cat:_content_load_sql}}
		/* =-=- CUSTOM BEGIN: {{$functionName}} -=-= */
{{if !empty($customBlock.$functionName)}}
{{$customBlock.$functionName}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$functionName}} -=-= */

		return $ret;
{{/if}}
