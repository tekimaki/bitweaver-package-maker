{{if $config.sections}}
function {{$config.name}}_content_section( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
		// Check permissions on the section
		global $gBitUser;
		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
			$pObject->verifyUserPermission('p_{{$config.name}}_{{$sectionName}}_section_view');
{{if $section.modes && in_array('edit',$section.modes)}}
            if( ( !empty( $pParamHash['action'] ) && $pParamHash['action'] == 'edit' )
                || !empty( $pParamHash['store_{{$sectionName}}'] ) ){
                $pObject->verifyUserPermission('p_{{$config.name}}_{{$sectionName}}_section_edit');
            }
{{/if}}
			break;
{{/foreach}}
		}
		${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
{{foreach from=$config.typemaps key=typemapName item=typemap}}
		$pObject->mInfo['{{$config.name}}']['{{$typemapName}}'] = ${{$config.name}}->get{{$typemapName|ucfirst}}ByContentId(); 
{{/foreach}}
		$pParamHash['has_section'] = TRUE;
{{if $section.modes && in_array('edit',$section.modes)}}
		// edit
		if( ( !empty( $pParamHash['action'] ) && $pParamHash['action'] == 'edit' ) ){
			{{$config.name}}_content_edit( $pObject, $pParamHash );
		}
{{/if}}
		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
            // store
            if( !empty( $pParamHash['store_{{$sectionName}}'] ) ){
                {{$config.name}}_content_store( $pObject, $pParamHash );
                if( count ($pObject->mErrors ) == 0 ) {
                    bit_redirect( $pObject->getDisplayUrl( $pParamHash['section'] ) );
                }else{
                    {{$config.name}}_content_preview( $pObject, $pParamHash );
                    $gBitSmarty->assign_by_ref( 'errors', $pObject->getErrors() ); {{* @TODO this is a little funky - for now the section must match the typemap name *}} 
                    $_REQUEST['action'] = 'edit'; //force us back to the edit panel
                }
            }

			break;
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
