	/** 
	 * verifies a data set for storage in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 * data is put into $pParamHash['{{$type.name}}_store'] for storage
	 */
	function verify{{$typemapName|ucfirst}}( &$pParamHash, $pIndex = NULL ){
		// Use $pParamHash here since it handles validation right
		// confirm all the fields are not null before we store a row 
		$hasValue = FALSE;
		foreach( $pParamHash as $key=>$value ) {
			if( $key != 'content_id' && !empty( $value ) ){
				$hasValue = TRUE;
			}
		}
{{if $typemap.attachments}}
		// if related to a file(s) if the file(s) was uploaded then validate the related fields also
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
		if( $pIndex == 0 && !empty($_FILES['{{$typemapName}}_{{$attachment}}']) && !empty($_FILES['{{$typemapName}}_{{$attachment}}']['type']) ){
			$hasValue = TRUE;
		}
{{/foreach}}
{{/if}}
		if( $hasValue ){
{{if $type.base_package eq "liberty" || $typemap.base_table eq "liberty_content"}}
			if( empty( $pParamHash['content_id'] ) && $this->isValid() ){
				$pParamHash['content_id'] = $this->mContentId; 
			}
{{/if}}
			$this->validate{{$typemapName|ucfirst}}Fields($pParamHash, $pIndex);
			if({{foreach from=$typemap.attachments key=attachment item=prefs name=attch}} empty( $pParamHash['{{$attachment}}_id'] ){{if !$smarty.foreach.attch.last}} ||{{/if}}{{/foreach}} ){
				$this->validate{{$typemapName|ucfirst}}Attachments( $pIndex );
			}else{
{{foreach from=$typemap.attachments key=attachment item=prefs name=attch}}
				$pParamHash['{{$type.name}}_store']['{{$attachment}}_id'] = $pParamHash['{{$attachment}}_id'];
{{/foreach}}
			}
			if( !empty( $pParamHash['{{$typemapName}}_id'] ) ){
				$pParamHash['{{$type.name}}_store']['{{$typemapName}}_id'] = $pParamHash['{{$typemapName}}_id'];
			}
			return( count( $this->mErrors )== 0 );
		}
		return FALSE;
	}
