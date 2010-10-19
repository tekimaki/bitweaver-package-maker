		// call edit service which loads any data necessary for form
		{{$config.name}}_content_edit( $pObject, $pParamHash );
		// write form data on top of content hash
		${{$config.name}} = new {{$config.class_name}}(); 
		${{$config.name}}->previewTypemaps( $pParamHash );
		$pObject->mInfo['{{$config.name}}'] = $pParamHash['{{$config.name}}_store'];
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == "one-to-one"}}
		// Merge one-to-one typemap {{$typemapName}}
		if (!empty($pParamHash['{{$config.name}}_store']['{{$typemapName}}'] )) {
			$pObject->mInfo = array_merge( $pObject->mInfo, $pParamHash['{{$config.name}}_store']['{{$typemapName}}'] );
		}
{{/if}}
{{/foreach}}
