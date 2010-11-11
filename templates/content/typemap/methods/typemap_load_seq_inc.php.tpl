	/**
	 * load a row from the {{$type.name}}_{{$typemapName}} table 
	 */
	 function load{{$typemapName|ucfirst}}( $p{{$typemapName|ucfirst}}Id = NULL ){
		$ret = array();
		if( $this->verifyId( $p{{$typemapName|ucfirst}}Id ) ){
			$query = "SELECT `{{$typemapName}}_id` as hash_key, `{{$typemapName}}_id`,{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$type.name}}_{{$typemapName}}` WHERE `{{$type.name}}_{{$typemapName}}`.{{$typemapName}}_id = ?";
			$ret = $this->mDb->getAssoc( $query, $bindVars );
		}
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
