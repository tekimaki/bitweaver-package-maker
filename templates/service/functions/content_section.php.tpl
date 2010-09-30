{{if $config.sections}}
function {{$config.name}}_content_section( $pObject, &$pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$config.name|strtoupper}} ) ){
		// Check permissions on the section
		global $gBitUser;
		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
			$pObject->verifyUserPermission('p_{{$config.name}}_{{$sectionName}}_section_view');
			break;
{{/foreach}}
		}

		switch( $pParamHash['section'] ){
{{foreach from=$config.sections key=sectionName item=section}}
		case '{{$sectionName}}':
{{/foreach}}
			${{$config.name}} = new {{$config.class_name}}( $pObject->mContentId ); 
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			$pObject->mInfo['{{$config.name}}']['{{$typemapName}}'] = ${{$config.name}}->get{{$typemapName|ucfirst}}ByContentId(); 
{{/foreach}}
			$pParamHash['has_section'] = TRUE;
			break;
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
