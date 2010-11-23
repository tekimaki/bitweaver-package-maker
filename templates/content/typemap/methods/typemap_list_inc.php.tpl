	function list{{$typemapName|ucfirst}}( $pParamHash = NULL ){
		$ret = $bindVars = array();

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql = " WHERE `{{$type.name}}_{{$typemapName}}`.content_id = ?";
		} elseif( $this->isValid() ){
			$bindVars[] = $this->mContentId;
			$whereSql = " WHERE `{{$type.name}}_{{$typemapName}}`.content_id = ?";
		}

		$query = "SELECT {{if $typemap.sequence}}`{{$typemapName}}_id` as hash_key, `{{$typemapName}}_id`,{{/if}}
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
 `{{$attachment}}_id`{{if !empty($typemap.fields) || !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$type.name}}_{{$typemapName}}`".$whereSql;
{{if $typemap.sequence}}
		$ret = $this->mDb->getAssoc( $query, $bindVars );
{{else}}
		$ret = $this->mDb->getArray( $query, $bindVars );
{{/if}}
{{* Need a LibertyContent context to parse with which sucks. *}}
{{assign var=parser value=false}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed' && !$parser}}
		$parser = new LibertyContent($this->mContentId);
		{{assign var=parser value=true}}
{{/if}}
{{/foreach}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
		// Parse all the {{$fieldName}}
		foreach ($ret as $key => &$data) {
			$parseHash['data'] = $data['{{$fieldName}}'];
			$parseHash['cache_extension'] = "{{$typemapName}}_{{$fieldName}}";
			$data['parsed_{{$fieldName}}'] = $parser->parseData($parseHash);
		}
{{/if}}
{{/foreach}}
		return $ret;
	}
