{literal}{strip}
{/literal}{include file="bitpackage:pkgmkr/smarty_file_header.tpl}{literal}
<div class="display {/literal}{$package}{literal} index">
	<div class="floaticon">
	</div><!-- end .floaticon -->

	<div class="header">
{* =-=- CUSTOM BEGIN: display_index_header -=-= *}{/literal}
{if !empty($customBlock.display_index_header)}{$customBlock.display_index_header}
{else}	<h1>{literal}{$indexTitle}{/literal}</h1>
{/if}{literal}{* =-=- CUSTOM END: display_index_header -=-= *}
	</div><!-- end .header -->

	<div class="body">
{* =-=- CUSTOM BEGIN: display_index_body -=-= *}{/literal}
{if !empty($customBlock.display_index_body)}{$customBlock.display_index_body}
{else}Enter custom home page html here{/if}
{literal}{* =-=- CUSTOM END: display_index_body -=-= *}
	</div><!-- end .body -->
</div><!-- end .display .index .{/literal}{$package}{literal} -->
{/strip}{/literal}
