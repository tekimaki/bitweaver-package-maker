	/** 
	 * verifies a data set for storage in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 * data is put into $pParamHash['{{$type.name}}_store'] for storage
	 */
	function verify{{$typemapName|ucfirst}}( &$pParamHash{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}, $pIndex = NULL{{/if}} ){
		// Use $pParamHash here since it handles validation right
{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}
		// confirm all the fields are not null before we store a row 
		$hasValue = FALSE;
		foreach( $pParamHash as $key=>$value ) {
			if( $key != 'content_id' && !empty( $value ) ){
				$hasValue = TRUE;
			}
		}
		if( $hasValue ){
{{if ($type.base_package eq "liberty" || $typemap.base_table eq "liberty_content" ) && !$typemap.graph}}
			if( empty( $pParamHash['content_id'] ) && $this->isValid() ){
				$pParamHash['content_id'] = $this->mContentId; 
			}
{{/if}}
{{if $typemap.graph}}
{{* determine if head or tail references the pObject - default is tail *}}
{{if $typemap.graph.head.input.value.object }}
			if( empty( $pParamHash['head_content_id'] ) && $this->isValid() ){
				$pParamHash['head_content_id'] = $this->mContentId; 
			}
{{else}}
			if( empty( $pParamHash['tail_content_id'] ) && $this->isValid() ){
				$pParamHash['tail_content_id'] = $this->mContentId; 
			}
{{/if}}
{{/if}}
			$this->validate{{$typemapName|ucfirst}}Fields( $pParamHash{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}, $pIndex{{/if}} );
{{if !empty($typemap.attachments)}}
			$this->validate{{$typemapName|ucfirst}}Attachments();
{{/if}}
			return( count( $this->mErrors )== 0 );
		}
		return FALSE;
{{else}}
{{if $type.base_package eq "liberty" || $typemap.base_table eq "liberty_content"}}
		if( empty( $pParamHash['content_id'] ) && $this->isValid() ){
			$pParamHash['content_id'] = $this->mContentId; 
		}
{{/if}}
		$this->validate{{$typemapName|ucfirst}}Fields($pParamHash);
{{if !empty($typemap.attachments)}}
		$this->validate{{$typemapName|ucfirst}}Attachments();
{{/if}}
		return( count( $this->mErrors )== 0 );
{{/if}}
	}
