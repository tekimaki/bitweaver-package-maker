		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = $ret['join_sql'] = $ret['where_sql'] = "";
{{foreach from=$typemaps item=typemap}}
{{if ($config.typemaps.$typemap.relation == 'one-to-one' && !$config.typemaps.$typemap.service_prefs) 
	 || ($config.typemaps.$typemap.service_prefs.load && in_array('content_list_sql',$config.typemaps.$typemap.service_prefs.load)) }}
		$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.attachments key=attachment item=prefs name=attachments}}, {{$config.name}}_{{$typemap}}.`{{$attachment}}_id`{{/foreach}} {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}}{{if $fieldName != 'content_id'}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty"}}liberty_content{{/if}}.`{{$fieldName}}`{{/if}}{{/foreach}}";
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
