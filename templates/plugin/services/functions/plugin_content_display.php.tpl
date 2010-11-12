{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == "one-to-one"}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
{{if $typemap.relation == "one-to-one"}}
		if( $pObject->isValid() ) {
			// Parse the {{$fieldName}}
			$parseHash['data'] = $pObject->mInfo['{{$fieldName}}'];
			$parseHash['cache_extension'] = "{{$typemapName}}_{{$fieldName}}";
			$pObject->mInfo['parsed_{{$fieldName}}'] = $pObject->parseData($parseHash);
		}
{{/if}}
{{/if}}
{{/foreach}}
{{elseif $typemap.relation == "one-to-many"}}
{{* @TODO this is might be a little heavy for read cases where we dont need everything
	Some sort of standard for triggering full load or a selective service load would help *}}
		// Get a list of the associated typemap data
		if( !empty( $pObject->mContentId ) ){
			if( empty( ${{$config.name}} ) ){
				${{$config.name}} = new {{$config.class_name}}(); 
			}
			$pObject->mInfo['{{$typemapName}}'] = ${{$config.name}}->list{{$typemapName|ucfirst}}(array( 'content_id' => $pObject->mContentId) ); 
		}
{{/if}}
{{/foreach}}
{{include file="custom_content_display_inc.php.tpl"}}
