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
{literal}}{/literal}
