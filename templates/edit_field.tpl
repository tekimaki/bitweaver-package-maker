	{strip}
{if !empty($field.validator.type)}
    {if $field.validator.type=="choice"}
	    <select name="{$fieldName}" id="{$fieldName}" {if $field.validator.muliple}multiple="multiple" {/if}>
		{foreach from=$field.validator.choices item=choice}
		<option>{$choice}</option>
		{/foreach}
	    </select>
    {elseif $field.validator.type=="date"}
    	    {ldelim}html_select_date prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}"{/foreach} {rdelim}
    {elseif $field.validator.type=="time"}
    	    {ldelim}html_select_time prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}"{/foreach} {rdelim}
    {elseif $field.validator.type=="timestamp"}
    	    {ldelim}html_select_date prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}"{/foreach} {rdelim}{ldelim}html_select_time prefix="" time=$gContent->getField("{$fieldName}") {foreach from=$field.smarty key=sk item=sv}{$sk}="{$sv}"{/foreach} {rdelim}
    {elseif $field.validator.type=="boolean"}
    	    <input type="checkbox" id="{$fieldName}" name="{$fieldName}" {ldelim}if $gContent->getField("{$fieldName}"){rdelim}checked="checked"{ldelim}/if{rdelim}/>
    {elseif $field.validator.type=="int" || $field.validator.type=="long"}
    	    <input type="text" id="{$fieldName}" name="{$fieldName}" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="float" || $field.validator.type=="double"}
    	    <input type="text" id={$fieldName}" name="{$fieldName}" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="email"}
    	    <input type="text" id={$fieldName}" name="{$fieldName}" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="url"}
    	    <input type="text" id={$fieldName}" name="{$fieldName}" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="regex"}
    	    <input type="text" id={$fieldName}" name="{$fieldName}" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {elseif $field.validator.type=="string"}
    	    <input type="text" id={$fieldName}" name="{$fieldName}" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {else}
    	    <input type="text" id={$fieldName}" name="{$fieldName}" value="{ldelim}$gContent->getField("{$fieldName}"){rdelim}" />
    {/if}
{else}
	<input type="text" name="{$fieldName}" value="{ldelim}$gContent->getField('{$fieldName}'){rdelim}" id="{$fieldName}" />
{/if}
{/strip}
