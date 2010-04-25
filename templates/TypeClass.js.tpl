{$type.class_name}{literal} = {
{/literal}{if $type.js}
{foreach from=$type.js.funcs item=func name=jsfuncs}
	{$func}:function( inputElm ){ldelim}
		/* =-=- CUSTOM BEGIN: {$func} -=-= */
{if !empty($customBlock.$func)}
{$customBlock.$func}
{else}

{/if}
		/* =-=- CUSTOM END: {$func} -=-= */
	{rdelim}{if !$smarty.foreach.jsfuncs.last},{/if}

{/foreach}
{/if}
{literal}
	/* =-=- CUSTOM BEGIN: functions -=-= */
{/literal}{if !empty($customBlock.functions)}
{$customBlock.functions}
{else}

{/if}{literal}
	/* =-=- CUSTOM END: functions -=-= */
}{/literal}
