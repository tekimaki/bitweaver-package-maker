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
  content_types:
{{foreach from=$ctypes item=ctype}}    - {{$ctype}}{{/foreach}}
