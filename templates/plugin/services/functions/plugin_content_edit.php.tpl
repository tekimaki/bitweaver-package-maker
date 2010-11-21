		global $gBitSmarty, $gBitThemes;
		// Prep any data we may need for the form
{{if $typemap.services.functions && in_array('content_display',$typemap.services.functions)}} 
		// pass through to display to load up content data
		{{$config.name}}_content_display( $pObject, $pParamHash );
{{elseif $typemap.services.functions && in_array('content_load',$typemap.services.functions)}} 
		// pass through to load to load up content data
		{{$config.name}}_content_load( $pObject, $pParamHash );
{{/if}}
{{assign var=jsColorIncluded value=false}}
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == 'one-to-many' && !$typemap.attachments && !$jsMultiFormIncluded}}
{{assign var=jsMultiFormIncluded value=true}}
{{assign var=jQueryIncluded value=true}}
		$gBitThemes->loadAjax( 'jquery' );
		$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/JQuery.BitMultiForm.js', FALSE );
{{/if}}
{{if $typemap.attachments}}
{{assign var=jsPreflightIncluded value=true}}
		$gBitThemes->loadAjax( 'MochiKit', array( 'DOM.js' ));
		$gBitThemes->loadJavascript( LIBERTY_PKG_PATH.'scripts/LibertyPreflight.js', FALSE );
{{/if}}
{{foreach from=$typemap.fields key=fieldName item=field}}
{{* reference fields *}}
{{if $field.input.type == "reference"}}
		$gBitThemes->loadAjax( 'jquery', array('ui/jquery.ui.all.js') );
		$gBitThemes->loadCss( UTIL_PKG_PATH . 'javascript/jQuery.Sortable.css'); 
		${{$config.class_name}} = new {{$config.class_name}}();
		${{$fieldName}}_options = ${{$config.class_name}}->get{{$typemapName|ucfirst}}{{$field.name|default:fieldName|ucfirst|replace:" ":""}}Options();
		$gBitSmarty->assign('{{$fieldName}}_options', ${{$fieldName}}_options);
{{* Plugin or package javascript handler? *}}
{{if !empty($PLUGIN) }}
		global $gBitSystem;
		$gBitThemes->loadJavascript( $gBitSystem->getPackagePluginPath("{{$plugin}}").'scripts/{{$config.class_name}}.js' );
{{else}}
		$gBitThemes->loadJavascript( {{$PACKAGE}}_PKG_PATH.'scripts/{{$config.class_name}}.js');
{{/if}}
{{/if}}
{{* hexcolor lib *}}
{{if !empty($field.validator.type) && $field.validator.type == 'hexcolor' && !$jsColorIncluded}}
{{assign var=jsColorIncluded value=true}}
		// hexcolor library
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
