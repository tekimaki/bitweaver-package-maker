{{if count($config.typemaps) > 0}}
{{literal}}
	// {{{ =================== TypeMap Functions for FieldSets ====================
{{/literal}}

	function verifyTypemaps( &$pParamHash ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// verify {{$typemapName}} fieldset
			$this->verify{{$typemapName|ucfirst}}($pParamHash);
{{/foreach}}
			return ( count($this->mErrors) == 0);
	}

	function previewTypemaps( &$pParamHash ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// verify {{$typemapName}} fieldset
			$this->preview{{$typemapName|ucfirst}}Fields($pParamHash);
{{/foreach}}
	}

	function storeTypemaps( &$pParamHash, $skipVerify = TRUE ) {
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// store {{$typemapName}} fieldset
			$this->store{{$typemapName|ucfirst}}Mixed($pParamHash, $skipVerify);
{{/foreach}}
			return ( count($this->mErrors) == 0);
	}

	function expungeTypemaps() {
		if ($this->isValid() ) {
			$paramHash = array('content_id' => $this->mContentId);
{{foreach from=$config.typemaps key=typemapName item=typemap}}
			// expunge {{$typemapName}} fieldset
			$this->expunge{{$typemapName|ucfirst}}($paramHash);
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
