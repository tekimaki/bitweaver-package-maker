{{include file="section_header_inc.tpl"}}
{{if $section.display_tpl == 'three_column'}}
{{include file="section_body_inc_three_column.tpl"}}
{{else}}
{{include file="section_body_inc.tpl"}}
{{/if}}