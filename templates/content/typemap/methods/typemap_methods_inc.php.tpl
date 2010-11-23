// {{literal}}{{{{{/literal}} =================== TypeMap Fieldset {{$typemapName|ucfirst}} Handlers  ====================


{{* load *}}
{{if $typemap.sequence}}
{{include file="typemap_load_seq_inc.php.tpl"}}
{{/if}}

{{* store *}}
{{if $typemap.graph}}
{{include file="typemap_store_graph_inc.php.tpl"}}
{{elseif $typemap.sequence && !$typemap.attachments}}
{{include file="typemap_store_seq_inc.php.tpl"}}
{{elseif $typemap.sequence && $typemap.relation eq 'one-to-many' && $typemap.attachments}}
{{include file="typemap_store_onetomany_attch_inc.php.tpl"}}
{{elseif !$typemap.relation || ($typemap.relation eq 'one-to-one' && !$typemap.attachments) || $typemap.relation eq 'many-to-many'}}
{{include file="typemap_store_inc.php.tpl"}}
{{elseif $typemap.relation eq 'one-to-many' && !$typemap.attachments}}
{{include file="typemap_store_onetomany_inc.php.tpl"}}
{{elseif $typemap.relation eq 'one-to-one' && $typemap.attachments}}
{{include file="typemap_store_attch_inc.php.tpl"}}
{{/if}}

{{* getbycontentid *}}
{{if !$typemap.sequence}}
{{if $typemap.relation eq 'one-to-one'}}
{{include file="typemap_getbycontentid_inc.php.tpl"}}
{{/if}}
{{/if}}
{{if $typemap.relation eq 'one-to-many'}}
{{include file="typemap_getbycontentid_onetomany_inc.php.tpl"}}
{{/if}}

{{* verify *}}
{{if $typemap.sequence && $typemap.relation eq 'one-to-many' && $typemap.attachments}}
{{include file="typemap_verify_onetomany_attch_inc.php.tpl"}}
{{else}}
{{include file="typemap_verify_inc.php.tpl"}}
{{/if}}

{{* expunge *}}
{{if $typemap.graph}}
{{include file="typemap_expunge_graph_inc.php.tpl"}}
{{else}}
{{include file="typemap_expunge_inc.php.tpl"}}
{{/if}}

{{* list *}}
{{if $typemap.graph}}
{{include file="typemap_list_graph_inc.php.tpl"}}
{{else}}
{{include file="typemap_list_inc.php.tpl"}}
{{/if}}

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

{{* prepverify *}}
{{if $typemap.graph}}
{{include file="typemap_prepverify_graph_inc.php.tpl"}}
{{else}}
{{include file="typemap_prepverify_inc.php.tpl"}}
{{/if}}

{{foreach from=$typemap.attachments key=attachment item=prefs}}
	/**
	 * expunge{{$attachment|ucfirst}}Attachment expunges the attachment id only from the typemap record
	 */
	function expunge{{$attachment|ucfirst}}Attachment($pObject, $pAttachmentId = NULL ) {
		if( $pObject->isValid() ){
			$locId['content_id'] = $pObject->mContentId;
			if (!empty($pAttachmentId)) {
				$locId['{{$attachment}}_id'] = $pAttachmentId;
			}
			$this->mDb->associateUpdate("{{$type.name}}_{{$typemapName}}", array('{{$attachment}}_id' => NULL), $locId);
		}
	}
{{/foreach}}

{{foreach from=$typemap.fields item=field key=fieldName name=fields}}
{{if $field.input.type == "reference" }}
	function get{{$typemapName|ucfirst}}{{$field.name|default:fieldName|ucfirst|replace:" ":""}}Options($pParams = NULL) {
		$ret = array();
		$bindVars = array();
		$whereSql = '';
		$query = "SELECT lc.`{{$field.validator.column}}` as hash_key, lc.`{{$field.input.desc_column}}` as desc FROM `".BIT_DB_PREFIX."{{$field.input.desc_table}}` lc";
{{if !empty($field.input.type_limit)}}
		$whereSql .= " AND lc.`content_type_guid` IN (";
{{foreach from=$field.input.type_limit item=guid name=guids}}
		$whereSql .= "?{{if !$smarty.foreach.guids.last}},{{/if}}";
		$bindVars[] = "{{$guid}}";
{{/foreach}}
		$whereSql .= ")";
{{/if}}
		if ( !empty($pParams['{{$fieldName}}_search'] ) ) {
                    $whereSql .= " AND lc.`{{$field.input.desc_column}}` LIKE ?";
		    $bindVars[] = "%".$pParams['{{$fieldName}}_search']."%";  
                }
		// Must come last
		if ( !empty($pParams['selected'] ) ) {
			$whereSql = preg_replace( '/^[\s]*AND\b/i', '', $whereSql );
			$whereSql = ' AND ('.$whereSql.') OR lc.`{{$field.validator.column}}` = ?';
			$bindVars[] = $pParams['selected'];
		}
		if ( !empty($whereSql) ) {
			$whereSql = preg_replace( '/^[\s]*AND\b/i', ' WHERE ', $whereSql );
			$query .= $whereSql;
		}
		$ret = $this->mDb->getAssoc($query, $bindVars);
		return $ret;	
	}
{{/if}}
{{/foreach}}

	// {{literal}}}}}{{/literal}}
