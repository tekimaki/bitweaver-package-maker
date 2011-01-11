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
		if( $hasValue ){
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
