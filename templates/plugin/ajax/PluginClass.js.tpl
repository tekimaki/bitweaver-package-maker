{{$config.class_name}} = {
{{foreach from=$config.typemaps item=typemap key=typemapName name=typemaps}}{{foreach from=$typemap.fields item=field key=fieldName name=fields}}{{if $field.input.type == "reference"}}
{{if $typemap.input.style == 'list'}}
	{{$typemapName}}_list:function( result, source, args ) {
               args += "&req=fetch_{{$typemapName}}_{{$fieldName}}_list";
               jQuery( "#"+source+" .multiform_input" ).each( function() {
                       args += "&exclude_content_id[]="+this.value;
               });
               BitBase.showSpinner();
               jQuery.ajax({
{{if empty($PLUGIN)}}
			url:BitSystem.urls.{{$package}}+'ajax.php',
{{else}}
			url:BitSystem.urls.{{$package}}_{{$plugin}}+'plugin_ajax.php',
{{/if}}
                        type:'POST',
                        context:document.body,
                        data: args,
                        success:function(dom){
                            jQuery('#'+result).replaceWith(dom);
                           BitBase.hideSpinner();
                        }
                      });
               return false;
	},
{{else}}
	fetch_{{$fieldName}}_list:function( fieldId, index, errMsg ){
		{{$fieldName}}_search = jQuery('#'+fieldId+'_search').val();
		selectedItem = jQuery('#'+fieldId).val();
		if (selectedItem == undefined) {
			selectedItem = -1;
		}
		BitBase.showSpinner();
        	jQuery.ajax({
{{if empty($PLUGIN)}}
			url:BitSystem.urls.{{$package}}+'ajax.php',
{{else}}
			url:BitSystem.urls.{{$package}}_{{$plugin}}+'plugin_ajax.php',
{{/if}}
                        type:'POST',
                        context:document.body,
                        data:{req:'fetch_{{$typemapName}}_{{$fieldName}}_list'{{if $typemap.relation == 'one-to-one'}}, {{$fieldName}}:{{$fieldName}}{{else}}, {{$fieldName}}_search:{{$fieldName}}_search, index:index, selected:selectedItem{{/if}} },
                        success:function(dom){
                            jQuery('#'+fieldId).replaceWith(dom);
			    BitBase.hideSpinner();
                        }
                      });
		return false;
	},
{{/if}}
{{/if}}{{/foreach}}{{/foreach}}
{{if $config.js}}
{{foreach from=$config.js.funcs item=func name=jsfuncs}}
	{{$func}}:function( inputElm ){
		/* =-=- CUSTOM BEGIN: {{$func}} -=-= */
{{if !empty($customBlock.$func)}}
{{$customBlock.$func}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$func}} -=-= */
	}{{if !$smarty.foreach.jsfuncs.last}},{{/if}}

{{/foreach}}
{{/if}}

	/* =-=- CUSTOM BEGIN: functions -=-= */
{{if !empty($customBlock.functions)}}
{{$customBlock.functions}}
{{else}}

{{/if}}
	/* =-=- CUSTOM END: functions -=-= */
}
