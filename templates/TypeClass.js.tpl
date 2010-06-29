{{$type.class_name}} = {
{{if $type.js}}
{{foreach from=$type.js.funcs item=func name=jsfuncs}}
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
