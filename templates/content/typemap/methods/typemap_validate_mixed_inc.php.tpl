	/**
	 * validate{{$typemapName|ucfirst}}FieldsMixed validates the fields in this type
	 */
	function validate{{$typemapName|ucfirst}}FieldsMixed(&$pParamHash) {
		$this->prep{{$typemapName|ucfirst}}Verify();
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			foreach($pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key => &$data) {
				$this->validate{{$typemapName|ucfirst}}Fields( $data, $key );
			}
		}
	}
