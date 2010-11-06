{{foreach from=$service.sql item=func}}
function {{$serviceName}}_{{$func}}( $pObject, $pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$serviceName|strtoupper}} ) ){
{{include file=$func|cat:'.php.tpl'}}
	}
}
{{/foreach}}
{{foreach from=$service.functions item=func}}
function {{$serviceName}}_{{$func}}( $pObject, $pParamHash ){
	if( $pObject->hasService( LIBERTY_SERVICE_{{$serviceName|strtoupper}} ) ){
{{include file=$func|cat:'.php.tpl'}}
	}
}
{{/foreach}}
