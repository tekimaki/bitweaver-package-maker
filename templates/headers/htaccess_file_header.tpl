 # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 # $Header: $
 #
{{foreach from=$config.copyright item=copyright}} # Copyright (c) {{$copyright.year}} {{$copyright.name}} {{$copyright.contact}}
{{/foreach}} #
 # All Rights Reserved. See below for details and a complete list of authors.
 #{{if $config.license}} {{$config.license.description}} {{if $config.license.url}}See {{$config.license.url}} for details{{/if}}{{/if}}
 #
 # $Id: $
 # @package {{$package|lower}}
 # @subpackage htaccess
 # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

