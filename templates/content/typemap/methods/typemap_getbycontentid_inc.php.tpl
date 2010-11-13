	/**
	 * get{{$typemapName|ucfirst}}ByContentId
	 */
	function get{{$typemapName|ucfirst}}ByContentId( $pContentId = NULL ){
		$ret = NULL;
		$contentId = !empty( $pContentId )?$pContentId:($this->isValid()?$this->mContentId:NULL);
		if( $this->verifyId( $contentId ) ){
			$query = "SELECT * FROM `{{$type.name}}_{{$typemapName}}` WHERE `{{$type.name}}_{{$typemapName}}`.content_id = ?";
			$result = $this->mDb->query( $query, array( $contentId ) );
            if( $result && $result->numRows() ) {
                $ret = $result->fields;
            } 
		}
		return $ret;
	}
