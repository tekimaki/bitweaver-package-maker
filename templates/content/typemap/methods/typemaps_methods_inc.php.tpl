{{if count($config.typemaps) > 0}}
{{literal}}
	// {{{ =================== TypeMap Functions for FieldSets ====================
{{/literal}}

	function verifyTypemaps( &$pParamHash ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// verify {{$typemapName}} fieldset
{{if $typemap.relation eq 'one-to-many'}}
			$this->verify{{$typemapName|ucfirst}}Mixed($pParamHash);
{{else}}
			$this->verify{{$typemapName|ucfirst}}($pParamHash);
{{/if}}
{{/foreach}}
			return ( count($this->mErrors) == 0);
	}

	function previewTypemaps( &$pParamHash ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// preview {{$typemapName}} fieldset
{{if $typemap.relation eq 'one-to-many'}}
			$this->preview{{$typemapName|ucfirst}}FieldsMixed($pParamHash);
{{else}}
			$this->preview{{$typemapName|ucfirst}}Fields($pParamHash);
{{/if}}
{{/foreach}}
	}

	function storeTypemaps( &$pParamHash, $skipVerify = TRUE ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// store {{$typemapName}} fieldset
{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}
			$this->store{{$typemapName|ucfirst}}Mixed($pParamHash, $skipVerify);
{{else}}
			$this->store{{$typemapName|ucfirst}}($pParamHash, $skipVerify);
{{/if}}
{{/foreach}}
			return ( count($this->mErrors) == 0);
	}

	function expungeTypemaps() {
		if ($this->isValid() ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// expunge {{$typemapName}} fieldset
{{if $typemap.graph}}
			${{$typemapName}}ExpungeHash = array('expunge_{{if $typemap.graph.head.input.value.object }}{{$typemap.graph.head.field}}{{else}}{{$typemap.graph.tail.field}}{{/if}}' => $this->mContentId);
			$this->expunge{{$typemapName|ucfirst}}(${{$typemapName}}ExpungeHash);
{{else}}
			${{$typemapName}}ExpungeHash = array('content_id' => $this->mContentId);
			$this->expunge{{$typemapName|ucfirst}}(${{$typemapName}}ExpungeHash);
{{/if}}
{{/foreach}}
		}
		return ( count($this->mErrors) == 0 );
	}

	function loadTypemaps() {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// load {{$typemapName}} list from sub map
			$this->mInfo['{{$typemapName}}'] = $this->list{{$typemapName|ucfirst}}();
{{/foreach}}
	}

{{literal}}
	// }}} -- end of TypeMap function for fieldsets
{{/literal}}

{{foreach from=$config.typemaps key=typemapName item=typemap}}
{{include file="typemap_methods_inc.php.tpl" type=$config}}

{{/foreach}}
{{/if}}
