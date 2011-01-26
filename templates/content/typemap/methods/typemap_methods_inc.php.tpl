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
{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many' }}
{{include file="typemap_verify_mixed_inc.php.tpl"}} 
{{/if}}
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

{{* preview *}}
{{if !$typemap.relation || $typemap.relation eq 'one-to-one'}}
{{include file="typemap_preview_inc.php.tpl"}}
{{elseif $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many' }}
{{include file="typemap_preview_onetomany_inc.php.tpl"}}
{{include file="typemap_preview_mixed_inc.php.tpl"}}
{{/if}}

{{* validate *}}
{{if !empty($typemap.attachments)}}
{{include file="typemap_validate_attachments_inc.php.tpl"}} 
{{/if}}
{{include file="typemap_validate_inc.php.tpl"}} 
{{if $typemap.relation eq 'one-to-many' || $typemap.relation eq 'many-to-many'}}
{{include file="typemap_validate_mixed_inc.php.tpl"}} 
{{/if}}

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
	function get{{$typemapName|ucfirst}}{{$field.name|default:fieldName|ucfirst|replace:" ":""}}Options(&$pParams = NULL) {
		if ( !empty($pParams['{{$fieldName}}_search'] ) ) {
			$pParams['find'] = $pParams['{{$fieldName}}_search'];
		}
{{if !empty($field.input.type_limit)}}
		$pParams['content_type_guid'] = array(
{{foreach from=$field.input.type_limit item=guid name=guids}}
			"{{$guid}}"{{if !$smarty.foreach.guids.last}},{{/if}}
{{/foreach}}

		);
{{/if}}
		$lc = new LibertyContent();
		$list = $lc->getContentList($pParams);
		$ret = array();
		foreach( $list as $values) {
			$ret[$values['content_id']] = $values['title'];
		}
		return $ret;
	}
{{/if}}
{{/foreach}}

	// {{literal}}}}}{{/literal}}
