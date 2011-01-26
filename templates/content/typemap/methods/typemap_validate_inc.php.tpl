	/**
	 * validate{{$typemapName|ucfirst}}Fields validates the fields in this type
	 */
	function validate{{$typemapName|ucfirst}}Fields( &$pParamHash{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}, $pIndex = NULL{{/if}} ) {
		$errors = array();
		$this->prep{{$typemapName|ucfirst}}Verify($pParamHash);
		if (!empty($pParamHash)) {
			LibertyValidator::validate(
				$this->mVerification['{{$type.name}}_{{$typemapName}}'],
				$pParamHash,
				$errors, 
				$pParamHash['{{$type.name}}_store'],
				$this->mServiceContent);
		}
		if( !empty( $errors ) ){
{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}} 
			if( is_null( $pIndex ) ){
				$errorsHash = &$this->mErrors['{{$typemapName}}'];
			}else{
				$errorsHash = &$this->mErrors['{{$typemapName}}'][$pIndex];
			}
			// errors already assigned need to merge errors
			if( !empty( $errorsHash ) ){
				$errorsHash = array_merge( $errorsHash, $errors );
			}else{
				$errorsHash = $errors;
			}
{{else}}
			// errors already assigned need to merge errors
			if( !empty( $this->mErrors['{{$typemapName}}'] ) ){
				$this->mErrors['{{$typemapName}}'] = array_merge( $this->mErrors['{{$typemapName}}'], $errors );
			}else{
				$this->mErrors['{{$typemapName}}'] = $errors;
			}
{{/if}}
		}
	}
