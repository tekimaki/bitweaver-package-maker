{if !empty($field.input.type)}
    {if $field.input.type=="choice"}
	    <select name="{$type.name}[{$fieldName}]" id="{$fieldName}" {if $field.validator.muliple}multiple="multiple" {/if}>
		{foreach from=$field.validator.choices item=choice}
		<option>{$choice}</option>
		{/foreach}
	    </select>
    {elseif $field.input.type=="hexcolor"}
    	    <input type="text" class="color {literal}{ldelim}{/literal}required:{if $field.validator.required}true{else}false{/if}{literal}{rdelim}{/literal}" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.input.type=="date"}
    	    {ldelim}html_select_date field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}" {/foreach} {rdelim}
    {elseif $field.input.type=="time"}
    	    {ldelim}html_select_time field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}" {/foreach} {rdelim}
    {elseif $field.input.type=="timestamp"}
    	    {ldelim}html_select_date field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}" {/foreach} {rdelim}{ldelim}html_select_time field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}"{/foreach} {rdelim}
    {elseif $field.input.type=="boolean"}
    	    <input type="checkbox" id="{$fieldName}" name="{$type.name}[{$fieldName}]" {ldelim}if $gContent->getField("{$fieldName}"){rdelim}checked="checked"{ldelim}/if{rdelim}/>
    {elseif $field.input.type=="int" || $field.input.type=="long"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.input.type=="float" || $field.input.type=="double"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.input.type=="email"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.input.type=="url"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.input.type=="regex"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.input.type=="string"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.input.type=="select"}
	{literal}{html_options id="{/literal}{$fieldName}{literal}" options=${/literal}{$field.input.optionsHashName}{literal} name="{/literal}{$type.name}[{$fieldName}{literal}]" selected=$gContent->getField('{/literal}{$fieldName}{literal}') {/literal}{foreach from=$field.input.jshandlers key=event item=handlerName}{$event}="{$handlerName}(this);" {/foreach}{literal} }{/literal}
    {else}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {/if}
{else}
	<input type="text" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField('{$fieldName}'){rdelim}" id="{$fieldName}" />
{/if}
