{literal} # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 # $Header: $
 #{/literal}
{foreach from=$config.copyright item=copyright} # Copyright (c) {$copyright.year} {$copyright.name} {$copyright.contact}
{/foreach}{literal} #
 # All Rights Reserved. See below for details and a complete list of authors.{/literal}
 #{if $config.license} {$config.license.description} {if $config.license.url}See {$config.license.url} for details{/if}{/if}{literal}
 #
 # $Id: $
 # @package {/literal}{$package|lower}{literal}
 # @subpackage htaccess
 # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
{/literal}
