	/** 
	 * verifies a data set for storage in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 * data is put into $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] for storage
	 */
	function verify{{$typemapName|ucfirst}}( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
        // confirm all the fields are not null before we store a row 
        $hasValue = FALSE;
        foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key=>$value ) {
            if( $key != 'content_id' && !empty( $value ) ){
                $hasValue = TRUE;
            }
        }
        if( $hasValue ){
			$this->validate{{$typemapName|ucfirst}}Fields($pParamHash);
			if({{foreach from=$typemap.attachments key=attachment item=prefs name=attch}} empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$attachment}}_id'] ){{if !$smarty.foreach.attch.last}} ||{{/if}}{{/foreach}} ){
				$this->validate{{$typemapName|ucfirst}}Attachments();
            }else{
{{foreach from=$typemap.attachments key=attachment item=prefs name=attch}}
				$pParamHash['{{$type.name}}_store']['{{$typemapName}}']['{{$attachment}}_id'] = $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$attachment}}_id'];
{{/foreach}}
            }
			if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemapName}}_id'] ) ){
				$pParamHash['{{$type.name}}_store']['{{$typemapName}}']['{{$typemapName}}_id'] = $pParamHash['{{$type.name}}']['{{$typemapName}}']['{{$typemapName}}_id'];
            }
			return( count( $this->mErrors )== 0 );
		}
		return FALSE;
	}
