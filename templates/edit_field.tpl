{if !empty($field.validator.type)}
    {if $field.validator.type=="choice"}
	    <select name="{$type.name}[{$fieldName}]" id="{$fieldName}" {if $field.validator.muliple}multiple="multiple" {/if}>
		{foreach from=$field.validator.choices item=choice}
		<option>{$choice}</option>
		{/foreach}
	    </select>
    {elseif $field.validator.type=="hexcolor"}
    	    <input type="text" class="color {literal}{ldelim}{/literal}required:{if $field.validator.required}true{else}false{/if}{literal}{rdelim}{/literal}" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="date"}
    	    {ldelim}html_select_date field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}" {/foreach} {rdelim}
    {elseif $field.validator.type=="time"}
    	    {ldelim}html_select_time field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}" {/foreach} {rdelim}
    {elseif $field.validator.type=="timestamp"}
    	    {ldelim}html_select_date field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}" {/foreach} {rdelim}{ldelim}html_select_time field_array="{$type.name}[{$fieldName}]" prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}"{/foreach} {rdelim}
    {elseif $field.validator.type=="boolean"}
    	    <input type="checkbox" id="{$fieldName}" name="{$type.name}[{$fieldName}]" {ldelim}if $gContent->getField("{$fieldName}"){rdelim}checked="checked"{ldelim}/if{rdelim}/>
    {elseif $field.validator.type=="int" || $field.validator.type=="long"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="float" || $field.validator.type=="double"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="email"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="url"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="regex"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="string"}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="reference"}
			{literal}{html_options id="{/literal}{$fieldName}{literal}" options=${/literal}{$field.validator.optionsHashName}{literal} name="{/literal}{$type.name}[{$fieldName}{literal}]" selected=$gContent->getField('{/literal}{$fieldName}{literal}')}{/literal}
    {else}
    	    <input type="text" id="{$fieldName}" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {/if}
{else}
	<input type="text" name="{$type.name}[{$fieldName}]" value="{ldelim}$gContent->getField('{$fieldName}'){rdelim}" id="{$fieldName}" />
{/if}
