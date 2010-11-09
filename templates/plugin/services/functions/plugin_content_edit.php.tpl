		global $gBitSmarty;
		// Prep any data we may need for the form
		// pass through to display to load up content data
		{{$config.name}}_content_display( $pObject, $pParamHash );
{{assign var=jsColorIncluded value=false}}
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == 'one-to-many' && !$typemap.attachments && !$jsMultiFormIncluded}}
{{assign var=jsMultiFormIncluded value=true}}
		global $gBitThemes;
		$gBitThemes->loadAjax( 'jquery' );
		$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/JQuery.BitMultiForm.js', FALSE );
{{/if}}
{{foreach from=$typemap.fields key=fieldName item=field}}
{{* hexcolor lib *}}
{{if !empty($field.validator.type) && $field.validator.type == 'hexcolor' && !$jsColorIncluded}}
{{assign var=jsColorIncluded value=true}}
		// hexcolor library
		global $gBitThemes;
		$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/jscolor/jscolor.js', FALSE );
{{/if}}
{{* select options *}}
{{if $field.input.type == 'select'}}
{{if $field.input.source == 'dataset'}}
{{* @TODO - set up the pathing and class name in prepConfig so this is automatic from the dataset value *}}
{{if $field.input.dataset == 'usstates'}}
		require_once( UTIL_PKG_PATH.'datasets/regions/us/class.USStates.php' );
		${{$field.input.optionsHashName}} = USStates::getDataset();
		$gBitSmarty->assign_by_ref( '{{$field.input.optionsHashName}}', ${{$field.input.optionsHashName}} );
{{/if}}
{{/if}}
{{/if}}
{{/foreach}}
{{/foreach}}
