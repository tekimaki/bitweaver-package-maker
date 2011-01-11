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
			// errors already assigned need to merge errors
			if( !empty( $this->mErrors['{{$type.name}}'][$pIndex] ) ){
				$this->mErrors['{{$type.name}}'][$pIndex] = array_merge( $this->mErrors['test'][$pIndex], $errors );
			}else{
				$this->mErrors['{{$type.name}}'][$pIndex] = $errors;
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
{{/foreach}}	
	}
