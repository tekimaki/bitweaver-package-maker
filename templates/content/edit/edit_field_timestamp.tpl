{html_select_date field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time={{if $inputValueAlt}}{{$inputValueAlt}}{{else}}$gContent->getField('{{$fieldName}}'){{/if}} {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}" {{/foreach}} }{html_select_time field_array="{{$namespace}}[{{$fieldName}}]" prefix="" time={{if $inputValue}}{{$inputValue}}{{else}}{$gContent->getField('{{$fieldName}}')}{{/if}} {{foreach from=$field.smarty key=sk item=sv}}{{$sk}}="{{$sv}}"{{/foreach}} }