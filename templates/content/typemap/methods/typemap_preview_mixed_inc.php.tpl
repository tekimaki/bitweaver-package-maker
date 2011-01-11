	/**
	 * preview{{$typemapName|ucfirst}}FieldsMixed prepares multiple fields in this type for preview
	 */
	function preview{{$typemapName|ucfirst}}FieldsMixed(&$pParamHash) {
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			foreach($pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key => &$data) {
				$this->preview{{$typemapName|ucfirst}}Fields( $data, $key );
			}
		}
	}

