// {{literal}}{{{{{/literal}} =================== TypeMap Fieldset {{$typemapName|ucfirst}} Handlers  ====================


{{* @TODO This only really works if the table has a sequnenced column, need some other way of getting a unique value if desired *}}
{{if $typemap.sequence}}
	/**
	 * load a row from the {{$type.name}}_{{$typemapName}} table 
	 */
	 function load{{$typemapName|ucfirst}}( $p{{$typemapName|ucfirst}}Id = NULL ){
		$ret = array();
		if( $this->verifyId( $p{{$typemapName|ucfirst}}Id ) ){
			$query = "SELECT `{{$typemapName}}_id` as hash_key, `{{$typemapName}}_id`,{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$type.name}}_{{$typemapName}}` WHERE `{{$type.name}}_{{$typemapName}}`.{{$typemapName}}_id = ?";
			$ret = $this->mDb->getAssoc( $query, $bindVars );
		}
{{* Need a LibertyContent context to parse with which sucks. *}}
{{assign var=parser value=false}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed' && !$parser}}
		$parser = new LibertyContent($this->mContentId);
		{{assign var=parser value=true}}
{{/if}}
{{/foreach}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
		// Parse all the {{$fieldName}}
		foreach ($ret as $key => &$data) {
			$parseHash['data'] = $data['{{$fieldName}}'];
			$parseHash['cache_extension'] = "{{$typemapName}}_{{$fieldName}}";
			$data['parsed_{{$fieldName}}'] = $parser->parseData($parseHash);
		}
{{/if}}
{{/foreach}}
		return $ret;
	}

	/**
	 * stores one or more records in the {{$type.name}}_{{$typemapName}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			$table = '{{$type.name}}_{{$typemapName}}';
			if( !empty( $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] )){
				foreach ($pParamHash['{{$type.name}}_store']['{{$typemapName}}'] as $key => &$data) {
{{if $type.base_package == "liberty" || $type.base_table == "liberty_content"}}
					if (!empty($pParamHash['{{$type.name}}']['content_id'])) {
						$data['content_id'] = $pParamHash['{{$type.name}}']['content_id'];
					} else {
						$data['content_id'] = $this->mContentId;
					}
{{/if}}
					// {{$typemapName}} id is set update the record
					if( !empty( $data['{{$typemapName}}_id'] ) ){
						$locId = array( '{{$typemapName}}_id' => $data['{{$typemapName}}_id'] );
						// unset( $data['{{$typemapName}}_id'] );
						$result = $this->mDb->associateUpdate( $table, $data, $locId );
					// {{$typemapName}} id is not set create a new record
					}else{
						$data['{{$typemapName}}_id'] = $this->mDb->GenID('{{$type.name}}_{{$typemapName}}_id_seq');
						$result = $this->mDb->associateInsert( $table, $data );
					}
				}
			}
		}
	}
{{else}}

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

	/**
	 * stores a single record in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 */
	function store{{$typemapName|ucfirst}}( &$pParamHash, $skipVerify = FALSE ){
{{if $typemap.relation eq 'one-to-one' && $typemap.base_table eq 'liberty_content'}}
		if( empty( $pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] ) && $this->isValid() ){
			$pParamHash['{{$type.name}}']['{{$typemapName}}']['content_id'] = $this->mContentId; 
		}
{{/if}}
		if( $skipVerify || $this->verify{{$typemapName|ucfirst}}( $pParamHash ) ) {
			if ( !empty( $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] )){
				$table = '{{$type.name}}_{{$typemapName}}';
{{if $typemap.relation eq 'one-to-one' && $typemap.base_table eq 'liberty_content'}}
				// record already exists, update it
				if( $this->get{{$typemapName|ucfirst}}ByContentId( $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] ) ){
					$locId = array( 'content_id' => $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] );
					unset( $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['content_id'] );
					$result = $this->mDb->associateUpdate( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'], $locId );
				// create a new record
				}else{
					$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] );
				}
{{else}}
				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] );
{{/if}}
			}
		}
		return count( $this->mErrors ) == 0;
	}
{{/if}}

	/**
	 * stores multiple records in the {{$type.name}}_{{$typemapName}} table
{{if !$typemap.sequence}}	 * uses bulk delete to avoid storage of duplicate records{{/if}} 
	 */
	function store{{$typemapName|ucfirst}}Mixed( &$pParamHash, $skipVerify = FALSE ){
		require_once( UTIL_PKG_PATH.'phpcontrib_lib.php' );
{{if !$typemap.sequence && $typemap.relation != 'one-to-one'}}
		$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` WHERE `content_id` = ?";
		$bindVars[] = $this->mContentId;
		$this->mDb->query( $query, $bindVars );
{{/if}} 
		if( !empty( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) ){
			if( is_array( $pParamHash['{{$type.name}}']['{{$typemapName}}'] ) && array_is_indexed( $pParamHash['{{$type.name}}']['{{$typemapName}}'] )){
				foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $data ){
					$storeHash['{{$type.name}}']['{{$typemapName}}'] = $data;
					$this->store{{$typemapName|ucfirst}}( $storeHash, $skipVerify );
				}
			}else{
				$this->store{{$typemapName|ucfirst}}( $pParamHash, $skipVerify );
			}
		}
		return count( $this->mErrors ) == 0;
	}

	/** 
	 * verifies a data set for storage in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 * data is put into $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] for storage
	 */
	function verify{{$typemapName|ucfirst}}( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
		$this->validate{{$typemapName|ucfirst}}Fields($pParamHash);
{{if !empty($typemap.attachments)}}
		$this->validate{{$typemapName|ucfirst}}Attachments();
{{/if}}
		return( count( $this->mErrors )== 0 );
	}

	function expunge{{$typemapName|ucfirst}}( &$pParamHash ){
		$ret = FALSE;
		$bindVars = array();
		$whereSql = "";

{{if $typemap.sequence}}
		// limit results by {{$typemapName}}_id
		if( !empty( $pParamHash['{{$typemapName}}_id'] ) ){
			$bindVars[] = $pParamHash['{{$typemapName}}_id'];
			$whereSql .= "`{{$typemapName}}_id` = ?";
		}

{{/if}}

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql .= "`content_id` = ?";
		}

		$query = "DELETE FROM `{{$type.name}}_{{$typemapName}}` WHERE ".$whereSql;
		$this->mDb->query( $query, $bindVars );

		if( $this->mDb->query( $query, $bindVars ) ){
			$ret = TRUE;
		}

		return $ret;
	}

	function list{{$typemapName|ucfirst}}( $pParamHash = NULL ){
		$ret = $bindVars = array();

		// limit results by content_id
		if( !empty( $pParamHash['content_id'] ) ){
			$bindVars[] = $pParamHash['content_id'];
			$whereSql = " WHERE `{{$type.name}}_{{$typemapName}}`.content_id = ?";
		} elseif( $this->isValid() ){
			$bindVars[] = $this->mContentId;
			$whereSql = " WHERE `{{$type.name}}_{{$typemapName}}`.content_id = ?";
		}

		$query = "SELECT {{if $typemap.sequence}}`{{$typemapName}}_id` as hash_key, `{{$typemapName}}_id`,{{/if}}
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
 `{{$typemapName}}_{{$attachment}}_id`{{if !empty($typemap.fields) || !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
 `{{$fieldName}}`{{if !$smarty.foreach.fields.last}},{{/if}}
{{/foreach}}
 FROM `{{$type.name}}_{{$typemapName}}`".$whereSql;
{{if $typemap.sequence}}
		$ret = $this->mDb->getAssoc( $query, $bindVars );
{{else}}
		$ret = $this->mDb->getArray( $query, $bindVars );
{{/if}}
{{* Need a LibertyContent context to parse with which sucks. *}}
{{assign var=parser value=false}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed' && !$parser}}
		$parser = new LibertyContent($this->mContentId);
		{{assign var=parser value=true}}
{{/if}}
{{/foreach}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
		// Parse all the {{$fieldName}}
		foreach ($ret as $key => &$data) {
			$parseHash['data'] = $data['{{$fieldName}}'];
			$parseHash['cache_extension'] = "{{$typemapName}}_{{$fieldName}}";
			$data['parsed_{{$fieldName}}'] = $parser->parseData($parseHash);
		}
{{/if}}
{{/foreach}}
		return $ret;
	}

	/**
	 * preview{{$typemapName|ucfirst}}Fields prepares the fields in this type for preview
	 */
	 function preview{{$typemapName|ucfirst}}Fields(&$pParamHash) {
		$this->prep{{$typemapName|ucfirst}}Verify();
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			LibertyValidator::preview(
				$this->mVerification['{{$type.name}}_{{$typemapName}}'],
				$pParamHash['{{$type.name}}']['{{$typemapName}}'],
				$pParamHash['{{$type.name}}_store']['{{$typemapName}}']);
{{* Need a LibertyContent context to parse with which sucks. *}}
{{assign var=parser value=false}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed' && !$parser}}
			$parser = new LibertyContent($this->mContentId);
			{{assign var=parser value=true}}
{{/if}}
{{/foreach}}
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
{{if $field.input.type == 'parsed'}}
			// Parse the {{$fieldName}}
			$parseHash['data'] = $pParamHash['{{$type.name}}_store']['{{$typemapName}}']['{{$fieldName}}'];
			$parseHash['cache_extension'] = "{{$type.name}}_{{$typemapName}}_{{$fieldName}}";
			$pParamHash['{{$typemapName}}_store']['{{$typemapName}}']['parsed_{{$fieldName}}'] = $parser->parseData($parseHash);
{{/if}}
{{/foreach}}
		}
	}

{{if !empty($typemap.attachments)}}
	/**
	 * validate{{$typemapName|ucfirst}}Attachments validates the attachments in this type
	 */
	function validate{{$typemapName|ucfirst}}Attachments() {
{{foreach from=$typemap.attachments key=attachment item=prefs name=attachments}}
		// Validate {{$attachment}}
{{if !empty($prefs.validator.format)}}
		LibertyValidator::validateAttachment("{{$typemapName}}_{{$attachment}}", 
			array( 
				"name" => "{{$prefs.name}}",
				"format" => array({{foreach from=$prefs.validator.format item=format name=format}}"{{$format}}"{{if !$smarty.foreach.format.last}},{{/if}}{{/foreach}})
			),
			$this
		);
{{/if}}
{{/foreach}}	
	}
{{/if}}

	/**
	 * validate{{$typemapName|ucfirst}}Fields validates the fields in this type
	 */
	function validate{{$typemapName|ucfirst}}Fields(&$pParamHash) {
		$this->prep{{$typemapName|ucfirst}}Verify();
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			LibertyValidator::validate(
				$this->mVerification['{{$type.name}}_{{$typemapName}}'],
				$pParamHash['{{$type.name}}']['{{$typemapName}}'],
				$this, $pParamHash['{{$type.name}}_store']['{{$typemapName}}']);
		}
	}

	/**
	 * validate{{$typemapName|ucfirst}}FieldsMixed validates the fields in this type
	 */
	function validate{{$typemapName|ucfirst}}FieldsMixed(&$pParamHash) {
		$this->prep{{$typemapName|ucfirst}}Verify();
		if (!empty($pParamHash['{{$type.name}}']['{{$typemapName}}'])) {
			foreach($pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key => &$data) {
				$this->validate{{$typemapName|ucfirst}}Fields( $pParamHash['{{$type.name}}']['{{$typemapName}}'][$key]);
			}
		}
	}

	/**
	 * prep{{$typemapName|ucfirst}}Verify prepares the object for input verification
	 */
	function prep{{$typemapName|ucfirst}}Verify() {
		if (empty($this->mVerification['{{$type.name}}_{{$typemapName}}'])) {

{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
	 		/* Validation for {{$fieldName}} */
{{if !empty($field.validator.type) && $field.validator.type != "no-input"}}
			$this->mVerification['{{$type.name}}_{{$typemapName}}']['{{$field.validator.type}}']['{{$fieldName}}'] = array(
				'name' => '{{$field.name|default:$fieldName|addslashes}}',
{{foreach from=$field.validator key=k item=v name=keys}}
{{if $k != 'type'}}
				'{{$k}}' => {{if is_array($v)}}array(
{{foreach from=$v key=vk item=vv name=values}}
					{{if is_numeric($vk)}}{{$vk}}{{else}}'{{$vk}}'{{/if}} => '{{$vv}}'{{if !$smarty.foreach.values.last}},{{/if}}

{{/foreach}}
					){{else}}'{{$v}}'{{/if}}{{if !$smarty.foreach.keys.last}},{{/if}}

{{/if}}
{{/foreach}}
			);
{{elseif empty($field.validator.type)}}
			$this->mVerification['{{$type.name}}_{{$typemapName}}']['null']['{{$fieldName}}'] = TRUE;
{{/if}}
{{/foreach}}

		}
	}

{{foreach from=$typemap.attachments key=attachment item=prefs}}
	/**
	 * store{{$attachment|ucfirst}}Attachment stores the attachment id
	 */
	function store{{$attachment|ucfirst}}Attachment($pObject, $pStoreHash) {
		if (!empty($pStoreHash['attachment_id']) && 
		    !empty($pStoreHash['content_id'])) {
			// Figure out if we have one at all and if it has an old value
			$old_id = $this->mDb->getAssoc("SELECT `content_id`, `{{$typemapName}}_{{$attachment}}_id` FROM `{{$type.name}}_{{$typemapName}}` WHERE `content_id` = ?", array('content_id' => $pStoreHash['content_id']));
			if (empty($old_id)) {
				$this->mDb->associateInsert("{{$type.name}}_{{$typemapName}}", array('{{$typemapName}}_{{$attachment}}_id' => $pStoreHash['attachment_id'], 'content_id' => $pStoreHash['content_id']));
			} else {
				$this->mDb->associateUpdate("{{$type.name}}_{{$typemapName}}", array('{{$typemapName}}_{{$attachment}}_id' => $pStoreHash['attachment_id']), array('content_id' => $pStoreHash['content_id']));
			}
			if (!empty($old_id) && !empty($old_id[$pStoreHash['content_id']])) {
				$pObject->expungeAttachment($old_id[$pStoreHash['content_id']]);
			}

		}
	}

	/**
	 * expunge{{$attachment|ucfirst}}Attachment expunges the attachment id only from the typemap record
	 */
	function expunge{{$attachment|ucfirst}}Attachment($pObject, $pAttachmentId = NULL ) {
		if( $pObject->isValid() ){
			$locId['content_id'] = $pObject->mContentId;
			if (!empty($pAttachmentId)) {
				$locId['{{$typemapName}}_{{$attachment}}_id'] = $pAttachmentId;
			}
			$this->mDb->associateUpdate("{{$type.name}}_{{$typemapName}}", array('{{$typemapName}}_{{$attachment}}_id' => NULL), $locId);
		}
	}
{{/foreach}}

	// {{literal}}}}}{{/literal}}
