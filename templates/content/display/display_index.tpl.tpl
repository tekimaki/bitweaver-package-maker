{strip}
{{include file="smarty_file_header.tpl}}
<div class="display {{$package}} index">
	<div class="floaticon">
	</div><!-- end .floaticon -->

	<div class="header">
{* =-=- CUSTOM BEGIN: display_index_header -=-= *}
{{if !empty($customBlock.display_index_header)}}{{$customBlock.display_index_header}}
{{else}}	<h1>{$indexTitle}</h1>
{{/if}}{* =-=- CUSTOM END: display_index_header -=-= *}
	</div><!-- end .header -->

	<div class="body">
{* =-=- CUSTOM BEGIN: display_index_body -=-= *}
{{if !empty($customBlock.display_index_body)}}{{$customBlock.display_index_body}}
{{else}}Enter custom home page html here{{/if}}
{* =-=- CUSTOM END: display_index_body -=-= *}
	</div><!-- end .body -->
</div><!-- end .display .index .{{$package}} -->
{/strip}
