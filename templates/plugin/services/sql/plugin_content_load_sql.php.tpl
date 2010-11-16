		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = $ret['join_sql'] = $ret['where_sql'] = "";
{{foreach from=$typemaps item=typemap}}
{{if $config.typemaps.$typemap.relation == 'one-to-one'}}
{{* load all the time *}}
{{if !$config.typemaps.$typemap.service_prefs 
	 || ($config.typemaps.$typemap.service_prefs.load && (in_array('content_display',$config.typemaps.$typemap.service_prefs.load) || in_array('content_load_sql',$config.typemaps.$typemap.service_prefs.load)))
}}
		$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.attachments key=attachment item=prefs name=attachments}}, {{$config.name}}_{{$typemap}}.`{{$attachment}}_id`{{/foreach}} {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}}{{if $fieldName != 'content_id'}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty_content"}}liberty_content{{/if}}.`{{$fieldName}}`{{/if}}{{/foreach}}";
		$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."{{$config.name}}_{{$typemap}}` {{$config.name}}_{{$typemap}} {{if $config.typemaps.typemap.base_table == "liberty_content"}}liberty_content{{/if}} ON ( lc.`content_id`={{$config.name}}_{{$typemap}}.`content_id` )";
{{*		$ret['where_sql'][] = ""; *}}
{{* load only in the case of a section request *}}
{{elseif $config.sections
	 && ($config.typemaps.$typemap.service_prefs.load && in_array('content_section',$config.typemaps.$typemap.service_prefs.load))	
}}
		if( !empty( $pParamHash['section'] ) ){
			switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
{{if ($section.view_typemaps && in_array($typemap,$section.view_typemaps))||($section.typemaps && in_array($typemap,$section.typemaps)) }}
			case '{{$sectionName}}':
				$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.attachments key=attachment item=prefs name=attachments}}, {{$config.name}}_{{$typemap}}.`{{$attachment}}_id`{{/foreach}} {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}}{{if $fieldName != 'content_id'}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty_content"}}liberty_content{{/if}}.`{{$fieldName}}`{{/if}}{{/foreach}}";
				$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."{{$config.name}}_{{$typemap}}` {{$config.name}}_{{$typemap}} {{if $config.typemaps.typemap.base_table == "liberty_content"}}liberty_content{{/if}} ON ( lc.`content_id`={{$config.name}}_{{$typemap}}.`content_id` )";
{{*				$ret['where_sql'][] = ""; *}}
				break;
{{/if}}
{{/foreach}}
			}
		}
{{/if}}
{{/if}}
{{/foreach}}
{{assign var=functionName value=content_load_sql}}
		/* =-=- CUSTOM BEGIN: {{$functionName}} -=-= */
{{if !empty($customBlock.$functionName)}}
{{$customBlock.$functionName}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$functionName}} -=-= */

		return $ret;
