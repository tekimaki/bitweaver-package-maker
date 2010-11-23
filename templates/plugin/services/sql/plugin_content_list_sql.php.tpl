		global $gBitSystem;
		$ret = array();
		$ret['select_sql'] = $ret['join_sql'] = $ret['where_sql'] = "";
{{foreach from=$typemaps item=typemap}}
{{* one-to-one *}}
{{if ($config.typemaps.$typemap.relation == 'one-to-one' && !$config.typemaps.$typemap.service_prefs) 
	 || ($config.typemaps.$typemap.service_prefs.load && in_array('content_list_sql',$config.typemaps.$typemap.service_prefs.load)) }}
		$ret['select_sql'] .= " {{foreach from=$config.typemaps.$typemap.attachments key=attachment item=prefs name=attachments}}, {{$config.name}}_{{$typemap}}.`{{$attachment}}_id`{{/foreach}} {{foreach from=$config.typemaps.$typemap.fields key=fieldName item=field name=fields}}{{if $fieldName != 'content_id'}},{{$config.name}}_{{$typemap}}{{if $config.typemaps.typemap.base_table == "liberty"}}liberty_content{{/if}}.`{{$fieldName}}`{{/if}}{{/foreach}}";
		$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."{{$config.name}}_{{$typemap}}` {{$config.name}}_{{$typemap}} {{if $config.typemaps.typemap.base_table == "liberty"}}liberty_content{{/if}} ON ( lc.`content_id`={{$config.name}}_{{$typemap}}.`content_id` )";
{{*		$ret['where_sql'] .= ""; *}}
{{*
		// return the values sent for pagination / url purposes
		$pParamHash['listInfo']['{{$config.name}}'] = $pParamHash['{{$config.name}}'];
		$pParamHash['listInfo']['ihash']['{{$config.name}}'] = $pParamHash['{{$config.name}}'];
*}}
{{* many-to-many graph *}}
{{elseif $config.typemaps.$typemap.relation == 'many-to-many' && $config.typemaps.$typemap.graph}}
{{* determine if head or tail references the pObject - default is tail *}}
{{if $config.typemaps.typemap.graph.head.input.value.object }}
		// limit the request by the graph relation
		if( !empty( $pParamHash['{{$config.typemaps.$typemap.graph.tail.field}}'] ) ){
			$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."liberty_edge le ON (le.`head_content_id`= lc.`content_id`)";
			$ret['where_sql'] .= " AND le.`tail_content_id` = ?";
			$bindVars[] = $pParamHash['{{$config.typemaps.typemap.graph.tail.field}}'];
			// return the values sent for pagination / url purposes
			$pParamHash['listInfo']['{{$config.typemaps.$typemap.graph.tail.field}}'] = $pParamHash['{{$config.typemaps.$typemap.graph.tail.field}}'];
			$pParamHash['listInfo']['ihash']['{{$config.typemaps.$typemap.graph.tail.field}}'] = $pParamHash['{{$config.typemaps.$typemap.graph.tail.field}}'];
		}
{{else}}
		if( !empty( $pParamHash['{{$config.typemaps.$typemap.graph.head.field}}'] ) ){
			$ret['join_sql'] .= " LEFT JOIN `".BIT_DB_PREFIX."liberty_edge ON (le.`tail_content_id`= lc.`content_id`)";
			$ret['where_sql'] .= " AND le.`head_content_id` = ?";
			$bindVars[] = $pParamHash['{{$config.typemaps.$typemap.graph.head.field}}'];
			// return the values sent for pagination / url purposes
			$pParamHash['listInfo']['{{$config.typemaps.$typemap.graph.head.field}}'] = $pParamHash['{{$config.typemaps.$typemap.graph.head.field}}'];
			$pParamHash['listInfo']['ihash']['{{$config.typemaps.$typemap.graph.head.field}}'] = $pParamHash['{{$config.typemaps.$typemap.graph.head.field}}'];
		}
{{/if}}
{{/if}}
{{/foreach}}
		return $ret;
