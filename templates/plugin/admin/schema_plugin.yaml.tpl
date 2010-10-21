---
{{$config.name}}: 
  version: 0.0.0
  required: false
  package: {{$package}}
  service_guid: {{$config.type}}
  requirements: 
{{if empty($config.requirements)}}
    liberty:
      min: 2.1.6
{{else}}{{foreach from=$config.requirements key=pkg item=reqs name=reqs}}
    {{$pkg}}:
      {{foreach from=$reqs key=k item=v name=values}}{{$k}}: {{$v}}{{/foreach}} 
{{/foreach}}{{/if}}
  description: {{$config.description}}
  license: 
    name: {{$config.license.name}}
    description: {{$config.license.description}} 
    url: {{$config.license.url}}
  tables: 
{{foreach from=$config.typemaps key=typemapName item=typemap}}
    {{include file="typemap_schema_inc.php.tpl" tablePrefix=$config.name}}
{{/foreach}}
{{foreach from=$config.tables key=tableName item=table}}
    {{include file="table_schema_inc.php.tpl" tableName=$tableName table=$table}}
{{/foreach}}
  constraints: 
{{* @TODO *}}
  indexes: 
{{* @TODO *}}
  sequences: 
{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{if $typemap.sequence}}
	{{$config.name}}_{{$typemapName}}_id_seq: {start: 1}
{{/if}}
{{/foreach}}
  defaults: 
{{foreach from=$config.typemaps key=typemapName item=typemap name=typemaps}}
{{foreach from=$typemap.defaults item=default}}
    - >
	INSERT INTO `{{$typemapName}}_data` {{$default}}
{{/foreach}}{{/foreach}}
  permissions: 
{{foreach from=$config.sections key=sectionName item=section name=sections}}
    p_{{$config.name}}_{{$sectionName}}_section_create:
      description: Can create a {{$sectionName}} section
      level: {{$section.permissions.default.create|default:registered}}
    p_{{$config.name}}_{{$sectionName}}_section_view:
      description: Can view {{$sectionName}} sections
      level: {{$section.permissions.default.view|default:basic}}
    p_{{$config.name}}_{{$sectionName}}_section_update:
      description: Can update any {{$sectionName}} section
      level: {{$section.permissions.default.update|default:editors}}
    p_{{$config.name}}_{{$sectionName}}_section_expunge:
      description: Can delete any {{$sectionName}} section
      level: {{$section.permissions.default.expunge|default:admin}}
    p_{{$config.name}}_{{$sectionName}}_section_admin:
      description: Can admin any {{$sectionName}} section
      level: {{$section.permissions.default.admin|default:admin}}
{{/foreach}}
{{foreach from=$config.typemaps key=typemapName item=typemap name=typemaps}}
    p_{{$config.name}}_{{$typemapName}}_service_create:
      description: Can create a {{$typemapName}} entry
      level: {{$typemap.permissions.default.create|default:registered}}
    p_{{$config.name}}_{{$typemapName}}_service_view:
      description: Can view {{$typemapName}} entries
      level: {{$typemap.permissions.default.view|default:basic}}
    p_{{$config.name}}_{{$typemapName}}_service_update:
      description: Can update any {{$typemapName}} entry
      level: {{$typemap.permissions.default.update|default:editors}}
    p_{{$config.name}}_{{$typemapName}}_service_expunge:
      description: Can delete any {{$typemapName}} entry
      level: {{$typemap.permissions.default.expunge|default:admin}}
    p_{{$config.name}}_{{$typemapName}}_service_admin:
      description: Can admin any {{$typemapName}} entry
      level: {{$typemap.permissions.default.admin|default:admin}}
{{/foreach}}
  service_guid: {{$config.type}}
{{foreach from=$config.content_types item=ctypes}}
{{if $ctypes}}
  content_types:
{{foreach from=$ctypes item=ctype}}    - {{$ctype}}{{/foreach}} 
{{/if}}
{{/foreach}}
  handler_file: {{$config.class_name}}.php
  api_handlers:
    sql:
{{foreach from=$config.services.functions key=func item=typemaps}}{{* sorry this is slighly annoying right here maybe cleanup in prepConfig -wjames *}}
{{if $func eq 'content_load_sql' || $func eq 'content_list_sql'}}
      {{$func}}: {{$config.name}}_{{$func}}
{{/if}}
{{/foreach}}
    function:
{{foreach from=$config.services.functions key=func item=typemaps}}
{{if $func != 'content_load_sql' && $func != 'content_list_sql'}}
      {{$func}}: {{$config.name}}_{{$func}}
{{/if}}
{{/foreach}}
{{if $config.sections}}{{* this should be handled in prepConfig *}}
      content_section: {{$config.name}}_content_section
{{/if}}
{{if $config.settings}}
      package_admin: {{$config.name}}_package_admin
{{/if}}
    tpl:
{{foreach from=$config.services.files key=file item=typemaps}}
{{if $file eq 'content_edit_mini'}}{{assign var=tplfile value='service_edit_mini_inc.tpl'}}{{/if}}
{{if $file eq 'content_edit_tab'}}{{assign var=tplfile value='service_edit_tab_inc.tpl'}}{{/if}}
      {{$file}}: 'bitpackage:{{$config.package}}/{{$config.name}}/{{$tplfile}}'
{{/foreach}}
{{if $config.sections}}{{* this should be handled in prepConfig *}}
      content_display_section: 'bitpackage:{{$config.package}}/{{$config.name}}/service_display_section.tpl'
{{/if}}
{{if $config.settings}}
      package_admin: 'bitpackage:{{$config.package}}/{{$config.name}}/service_admin_inc.tpl'
{{/if}}
