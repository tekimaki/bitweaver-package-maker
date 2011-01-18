	function verify{{$typemapName|ucfirst}}Mixed( &$pParamHash ){
		if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){ 
			foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $index=>&$data ){
				if( empty( $data['content_id'] ) && $this->isValid() ){
					$data['content_id'] = $this->mContentId; 
				}
				$this->verify{{$typemapName|ucfirst}}( $data, $index );
			}
		}
		return count( $this->mErrors ) == 0;
	}
