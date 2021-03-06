{{if $config.sections}}
function {{$config.name}}_content_section( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
{{* permission checks *}}
		// Check permissions on the section
		global $gBitUser, $gBitSmarty, $gBitThemes, $gBitSystem;
		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
			$pObject->verifyUserPermission('p_{{$config.name}}_{{$sectionName}}_section_view');
{{if $section.modes && in_array('edit',$section.modes)}}
            if( ( !empty( $pParamHash['action'] ) && $pParamHash['action'] == 'edit' )
                || !empty( $pParamHash['store_{{$sectionName}}'] ) ){
                $pObject->verifyUserPermission('p_{{$config.name}}_{{$sectionName}}_section_update');
            }
{{/if}}
			break;
{{/foreach}}
		}
{{* data processing *}}
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
{{* data processing: load *}}
			// load (for view and edit modes)
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{* @TODO the following if should also account for section based editiing and loading the data *}}
{{if ($section.view_typemaps && in_array($typemapName,$section.view_typemaps))||($section.typemaps && in_array($typemapName,$section.typemaps)) }}
{{if $typemap.relation == "one-to-one"}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
{{if $typemap.service_prefs.load && in_array('content_section',$typemap.service_prefs.load) }}
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
{{if !$typemap.service_prefs || ($typemap.service_prefs.load && in_array('content_section',$typemap.service_prefs.load)) }}
			// Get a list of the associated typemap {{$typemapName|ucfirst}}
			if( !empty( $pObject->mContentId ) ){
				if( empty( ${{$config.name}} ) ){
					${{$config.name}} = new {{$config.class_name}}(); 
				}
				$pObject->mInfo['{{$typemapName}}'] = ${{$config.name}}->list{{$typemapName|ucfirst}}(array( 'content_id' => $pObject->mContentId) ); 
			}
{{/if}}
{{/if}}
{{/if}}
{{/foreach}}
			$pParamHash['has_section'] = TRUE;
{{if $section.page_title}}
			$pParamHash['section_page_title'] = tra('{{$section.page_title}}');
{{/if}}
{{* data processing: edit *}}
{{if $section.modes && in_array('edit',$section.modes)}}
			// edit
			if( ( !empty( $pParamHash['action'] ) && $pParamHash['action'] == 'edit' ) ){
				{{$config.name}}_content_edit( $pObject, $pParamHash );
				$gBitThemes->loadAjax( 'jquery' );
				$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/JQuery.placeholder.js', TRUE );
			}
{{* data processing: store *}}
            // store
            if( !empty( $pParamHash['store_{{$sectionName}}'] ) ){
                {{$config.name}}_content_store( $pObject, $pParamHash );
                if( count ($pObject->mErrors ) == 0 ) {
                    {{if $section.success_redirect == 'edit'}}
					
					if( $gBitSystem->getConfig('edit_success_return_to_form')=='n' ){
						bit_redirect( $pObject->getDisplayUrl( $pParamHash['section'] ) );
					}else {
						{{$config.name}}_content_preview( $pObject, $pParamHash );
						$gBitSmarty->assign_by_ref( 'success', tra( 'Successfully updated {{$sectionName|replace:"_":" "}}.' ) );
						$_REQUEST['action'] = 'edit';
					}
					{{else}}
					bit_redirect( $pObject->getDisplayUrl( $pParamHash['section'] ) );
					{{/if}}

                }else{
                    {{$config.name}}_content_preview( $pObject, $pParamHash );
                    $gBitSmarty->assign_by_ref( 'errors', $pObject->getErrors() ); {{* @TODO this is a little funky - for now the section must match the typemap name *}} 
                    $_REQUEST['action'] = 'edit'; //force us back to the edit panel
                }
            }

			break;
{{/if}}
{{/foreach}}
		}
		/* =-=- CUSTOM BEGIN: content_section_function -=-= */
{{if !empty($customBlock.content_section_function)}}
{{$customBlock.content_section_function}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: content_section_function -=-= */
	}
}
{{/if}}
