	/** 
	 * verifies a data set for storage in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 * data is put into $pParamHash['{{$type.name}}_store'] for storage
	 */
	function verify{{$typemapName|ucfirst}}( &$pParamHash{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}, $pIndex = NULL{{/if}} ){
		// Use $pParamHash here since it handles validation right
{{if $typemap.relation eq 'one-to-many'}}
        // confirm all the fields are not null before we store a row 
        $hasValue = FALSE;
		foreach( $pParamHash as $key=>$value ) {
            if( $key != 'content_id' && !empty( $value ) ){
                $hasValue = TRUE;
            }
        }
        if( $hasValue ){
			$this->validate{{$typemapName|ucfirst}}Fields( $pParamHash{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}, $pIndex{{/if}} );
{{if !empty($typemap.attachments)}}
			$this->validate{{$typemapName|ucfirst}}Attachments();
{{/if}}
			return( count( $this->mErrors )== 0 );
		}
		return FALSE;
{{else}}
		$this->validate{{$typemapName|ucfirst}}Fields($pParamHash);
{{if !empty($typemap.attachments)}}
		$this->validate{{$typemapName|ucfirst}}Attachments();
{{/if}}
		return( count( $this->mErrors )== 0 );
{{/if}}
	}
