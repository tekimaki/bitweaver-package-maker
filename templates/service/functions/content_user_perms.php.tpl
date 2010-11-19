{{assign var=functionName value=$serviceName|cat:_content_user_perms}}
		/* =-=- CUSTOM BEGIN: {{$functionName}} -=-= */
{{if !empty($customBlock.$functionName)}}
{{$customBlock.$functionName}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$functionName}} -=-= */
