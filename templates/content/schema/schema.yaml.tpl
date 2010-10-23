---
{{$package}}: 
  version: 0.0.0
  required: false
  requirements: 
{{if empty($config.requirements)}}
    liberty:
      min: 2.1.6
{{else}}{{foreach from=$config.requirements key=pkg item=reqs name=reqs}}
    {{$pkg}}:
      {{foreach from=$reqs key=k item=v name=values}}{{$k}}: {{$v}}{{/foreach}}

{{/foreach}}
{{/if}} 
  description: {{$config.description}}
  license: 
    name: {{$config.license.name}}
    description: {{$config.license.description}} 
    url: {{$config.license.url}}
  homeable: true
  pluggable: {{$config.pluggable}} 
  tables: 
{{* content types *}}
{{foreach from=$config.types key=typeName item=type}}
    {{include file="type_schema_inc.yaml.tpl"}}
{{foreach from=$type.typemaps key=typemapName item=typemap}}
    {{include file="typemap_schema_inc.yaml.tpl" tablePrefix=$typeName}}
{{/foreach}}
{{/foreach}}
{{* services *}}
{{foreach from=$config.services key=serviceName item=service}}
    {{include file="service_schema_inc.yaml.tpl"}}
{{foreach from=$service.typemaps key=typemapName item=typemap}}
    {{include file="typemap_schema_inc.yaml.tpl" tablePrefix=$serviceName}}
{{/foreach}}
{{/foreach}}
{{* tables *}}
{{foreach from=$config.tables key=tableName item=table}}
    {{include file="table_schema_inc.yaml.tpl" tableName=$tableName table=$table}}
{{/foreach}}
  constraints: 
{{* @TODO *}}
  indexes: 
{{* @TODO *}}
  sequences: 
{{foreach from=$config.types key=typeName item=type name=types}}
    {{$typeName}}_data_id_seq: {start: 1}
{{foreach from=$type.typemaps key=typemapName item=typemap}}
{{if $typemap.sequence}}
    {{$typeName}}_{{$typemapName}}_id_seq: {start: 1}
{{/if}}
{{/foreach}}
{{/foreach}}
  preferences: 
{{foreach from=$config.types key=typeName item=type name=types}}
    {{$typeName}}_default_ordering: {{$typeName}}_id_desc
{{*    list_{{$typeName}}_id: 'y' *}}
{{if $type.title}}
    {{$typeName}}_list_title: 'y'
{{/if}}
{{if $type.summary}}
    {{$typeName}}_list_summary: 'y'
{{/if}}
{{if $config.homeable}}
    {{$package}}_{{$typeName}}_home_id: 0
{{if $smarty.foreach.types.first}}
    {{$package}}_home_type: {{$typeName}}
{{/if}}
{{/if}}
{{/foreach}}
  defaults: 
{{foreach from=$config.types key=typeName item=type name=types}}
{{foreach from=$type.defaults item=default}}
    - >
    INSERT INTO `{{$typeName}}_data` {{$default}}
{{/foreach}}{{/foreach}}
  permissions: 
    p_{{$package}}_admin:
      description: Can admin the {{$package}} package
      level: admin
    p_{{$package}}_view:
      description: Can view the {{$package}} package
      level: basic
{{foreach from=$config.types key=typeName item=type name=types}}
    p_{{$typeName}}_create:
      description:  Can create a {{$typeName}} entry
      level: {{$type.permissions.default.create|default:registered}}
    p_{{$typeName}}_view:
      description:  Can view {{$typeName}} entries
      level: {{$type.permissions.default.view|default:basic}}
    p_{{$typeName}}_update:
      description: Can update any {{$typeName}} entry
      level: {{$type.permissions.default.update|default:editors}}
    p_{{$typeName}}_expunge:
      description: Can delete any {{$typeName}} entry
      level: {{$type.permissions.default.expunge|default:admin}}
    p_{{$typeName}}_admin:
      description: Can admin any {{$typeName}} entry
      level: {{$type.permissions.default.admin|default:admin}}
{{/foreach}}
{{foreach from=$config.services key=serviceName item=service name=services}}
    p_{{$serviceName}}_create:
      description:  Can create a {{$serviceName}} entry
      level: {{$service.permissions.default.create|default:registered}}
    p_{{$serviceName}}_view:
      description:  Can view {{$serviceName}} entries
      level: {{$service.permissions.default.view|default:basic}}
    p_{{$serviceName}}_update:
      description: Can update any {{$serviceName}} entry
      level: {{$service.permissions.default.update|default:editors}}
    p_{{$serviceName}}_expunge:
      description: Can delete any {{$serviceName}} entry
      level: {{$service.permissions.default.expunge|default:admin}}
    p_{{$serviceName}}_admin:
      description: Can admin any {{$serviceName}} entry
      level: {{$service.permissions.default.admin|default:admin}}
{{/foreach}}
  contenttypes:
{{foreach from=$config.types key=typeName item=type name=types}}
    {{$type.class_name}}: {{$type.class_name}}.php
{{/foreach}}
{{if !empty($config.services) }}
  plugins:
{{* TODO: add plugins here and refactor plugin yaml to use three keys instead of
overloading the one functions key*}}
{{foreach from=$config.services item=service key=serviceName name=services}}
    {{$serviceName}}:
      handler_file: {{$service.class_name}}.php
      api_handlers:
{{if !empty($service.sql) }}
        sql:
{{foreach from=$service.sql item=api_item key=api_key name=serviceapis}}
          {{$api_item}}: {{$serviceName}}_{{$api_item}}
{{/foreach}}
{{/if}}
{{if !empty($service.functions) }}
        functions:
{{foreach from=$service.functions item=api_item key=api_key name=serviceapis}}
          {{$api_item}}: {{$serviceName}}_{{$api_item}}
{{/foreach}}
{{/if}}
{{if !empty($service.templates) }}
        tpl:
{{foreach from=$service.templates item=api_item key=api_key name=serviceapis}}
          {{$api_item}}: "bitpackage:{{$package}}/{{$serviceName}}_{{$api_item}}_inc.tpl"
{{/foreach}}
{{/if}}
{{/foreach}}
{{/if}}