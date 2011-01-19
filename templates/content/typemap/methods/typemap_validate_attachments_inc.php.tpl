	/**
	 * validate{{$typemapName|ucfirst}}Attachments validates the attachments in this type
	 */
	function validate{{$typemapName|ucfirst}}Attachments({{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}} $pIndex {{/if}}) {
		$errors = array();
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
		// Validate {{$attachment}}
{{if !empty($prefs.validator.format)}}
		LibertyValidator::validateAttachment("{{$typemapName}}_{{$attachment}}", 
			array( 
				"name" => "{{$prefs.name}}",
				"format" => array({{foreach from=$prefs.validator.format item=format name=format}}"{{$format}}"{{if !$smarty.foreach.format.last}},{{/if}}{{/foreach}})
			),
			$errors
		);
{{/if}}
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
{{/foreach}}	
	}
