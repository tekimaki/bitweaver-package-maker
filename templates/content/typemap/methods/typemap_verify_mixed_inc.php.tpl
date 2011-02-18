	function verify{{$typemapName|ucfirst}}Mixed( &$pParamHash ){
		if( !empty($pParamHash['{{$type.name}}']['{{$typemapName}}']) && is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){ 
			foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $index=>&$data ){
				$this->verify{{$typemapName|ucfirst}}( $data, $index );
			}
		}
		return count( $this->mErrors ) == 0;
	}
