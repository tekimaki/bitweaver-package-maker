	/**
	 * validate{{$typemapName|ucfirst}}Fields validates the fields in this type
	 */
	function validate{{$typemapName|ucfirst}}Fields( &$pParamHash{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}, $pIndex = NULL{{/if}} ) {
		$errors = array();
		$this->prep{{$typemapName|ucfirst}}Verify();
		if (!empty($pParamHash)) {
			LibertyValidator::validate(
				$this->mVerification['{{$type.name}}_{{$typemapName}}'],
				$pParamHash,
				$errors, $pParamHash['{{$type.name}}_store']);
		}
		if( !empty( $errors ) ){
{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}} 
			if( is_null( $pIndex ) ){
				$errorsHash = &$this->mErrors['{{$type.name}}'];
			}else{
				$errorsHash = &$this->mErrors['{{$type.name}}'][$pIndex];
			}
			// errors already assigned need to merge errors
			if( !empty( $errorsHash ) ){
				$errorsHash = array_merge( $errorsHash, $errors );
			}else{
				$errorsHash = $errors;
			}
{{else}}
			// errors already assigned need to merge errors
			if( !empty( $this->mErrors['{{$type.name}}'] ) ){
				$this->mErrors['{{$type.name}}'] = array_merge( $this->mErrors['{{$type.name}}'], $errors );
			}else{
				$this->mErrors['{{$type.name}}'] = $errors;
			}
{{/if}}
		}
	}
