{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.relation == "one-to-one"}}
{{elseif $typemap.relation == "one-to-many"}}
{{/if}}
{{/foreach}}
{{include file="custom_content_load_inc.php.tpl"}}
