	/**
	 * preview{{$typemapName|ucfirst}}Fields prepares the fields in this type for preview
	 */
	function preview{{$typemapName|ucfirst}}Fields(&$pParamHash) {
		$preview = array();
		$this->prep{{$typemapName|ucfirst}}Verify($pParamHash);
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			LibertyValidator::preview(
				$this->mVerification['{{$type.name}}_{{$typemapName}}'],
				$pParamHash['{{$type.name}}']['{{$typemapName}}'],
				$preview);
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
			// Parse the {{$fieldName}}
			$parseHash['data'] = $pParamHash['{{$fieldName}}'];
			$parseHash['cache_extension'] = "{{$type.name}}_{{$typemapName}}_{{$fieldName}}";
			$preview['parsed_{{$fieldName}}'] = $parser->parseData($parseHash);
{{/if}}
{{/foreach}}
			if( !empty( $preview ) ) {
				if( !empty( $this->mServiceContent->mInfo ) ){
					$this->mServiceContent->mInfo = array_merge($this->mServiceContent->mInfo, $preview);
				}else{
					$this->mServiceContent->mInfo = $preview;
				}
			}
		}
	}

