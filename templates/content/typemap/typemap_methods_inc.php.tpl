// {{literal}}{{{{{/literal}} =================== TypeMap Fieldset {{$typemapName|ucfirst}} Handlers  ====================


{{* @TODO This only really works if the table has a sequnenced column, need some other way of getting a unique value if desired *}}
{{if $typemap.sequence}}

{{include file="typemap_load_seq_inc.php.tpl"}}

{{include file="typemap_store_seq_inc.php.tpl"}}

{{* Not sequenced tables *}}
{{else}}

{{* switch store and storeMixed based on mapping and attachments *}}
{{if !$typemap.relation || ($typemap.relation eq 'one-to-one' && !$typemap.attachments)}}
{{include file="typemap_store_inc.php.tpl"}}
{{elseif $typemap.relation eq 'one-to-many' && !$typemap.attachments}}
{{include file="typemap_store_onetomany_inc.php.tpl"}}
{{elseif $typemap.relation eq 'one-to-one' && $typemap.attachments}}
{{include file="typemap_store_attach_inc.php.tpl"}}
{{elseif $typemap.relation eq 'one-to-many' && !$typemap.attachments}}
{{include file="typemap_store_onetomany_attach_inc.php.tpl"}}
{{/if}}

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

{{/if}}
{{* end of sequence switch *}}

	/** 
	 * verifies a data set for storage in the {{$type.name}}_{{$typemapName|ucfirst}} table
	 * data is put into $pParamHash['{{$type.name}}_store']['{{$typemapName}}'] for storage
	 */
	function verify{{$typemapName|ucfirst}}( &$pParamHash ){
		// Use $pParamHash here since it handles validation right
{{if $typemap.relation eq 'one-to-many'}}
        // confirm all the fields are not null before we store a row 
        $hasValue = FALSE;
        foreach( $pParamHash['{{$type.name}}']['{{$typemapName}}'] as $key=>$value ) {
            if( $key != 'content_id' && !empty( $value ) ){
                $hasValue = TRUE;
            }
        }
        if( $hasValue ){
			$this->validate{{$typemapName|ucfirst}}Fields($pParamHash);
{{if !empty($typemap.attachments)}}
			$this->validate{{$typemapName|ucfirst}}Attachments();
{{/if}}
			return( count( $this->mErrors )== 0 );
		}
		return FALSE;
{{else}}
		$this->validate{{$typemapName|ucfirst}}Fields($pParamHash);
{{if !empty($typemap.attachments)}}
		$this->validate{{$typemapName|ucfirst}}Attachments();
{{/if}}
		return( count( $this->mErrors )== 0 );
{{/if}}
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
