		global $gBitSmarty;

		// pass through to display to load up content data
		{{$serviceName}}_content_display( $pObject, $pParamHash );

{{foreach from=$service.fields key=fieldName item=field}}
		${{$serviceName}} = new {{$service.class_name}}();
{{if $field.validator.type == 'reference' && ($field.input.type == 'select' || $field.input.type == 'checkbox')}}

		// Load options for {{$field.name}}
		${{$field.input.optionsHashName}} =  ${{$serviceName}}->get{{$field.name|replace:" ":""}}Options( $listHash );
		$gBitSmarty->assign('{{$field.input.optionsHashName}}', ${{$field.input.optionsHashName}});

{{/if}}
{{/foreach}}
