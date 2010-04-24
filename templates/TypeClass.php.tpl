{literal}<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim: :set fdm=marker : */
{/literal}{include file="bitpackage:pkgmkr/php_file_header.tpl"}{literal}
/*
   -==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   Portions of this file are modifiable

   Anything between the CUSTOM BEGIN: and CUSTOM END:
   comments will be preserved on regeneration of this
   file.
   -==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

/**
* {/literal}{$type.class_name}{literal} class
* {/literal}{$type.description}{literal}
*
* @version $Revision: $
* @class {/literal}{$type.class_name}{literal}
*/

require_once( {/literal}{$type.base_package|upper}{literal}_PKG_PATH.'{/literal}{$type.base_class}{literal}.php' );
require_once( PKGMKR_PKG_PATH . 'LibertyValidator.php' );
{/literal}
/* =-=- CUSTOM BEGIN: require -=-= */
{if !empty($customBlock.require)}
{$customBlock.require}
{else}

{/if}
/* =-=- CUSTOM END: require -=-= */
{literal}

/**
* This is used to uniquely identify the object
*/
define( 'BIT{/literal}{$type.name|upper}{literal}_CONTENT_TYPE_GUID', 'bit{/literal}{$type.name|lower}{literal}' );

class {/literal}{$type.class_name}{literal} extends {/literal}{$type.base_class}{literal} {
	/**
	 * m{/literal}{$type.name|capitalize}{literal}Id Primary key for our mythical {/literal}{$type.name|capitalize}{literal} class object & table
	 *
	 * @var array
	 * @access public
	 */
	var $m{/literal}{$type.name|capitalize}{literal}Id;

	var $mVerification;

	/**
	 * {/literal}{$type.class_name}{literal} During initialisation, be sure to call our base constructors
	 *
	 * @param numeric $p{/literal}{$type.name|capitalize}{literal}Id
	 * @param numeric $pContentId
	 * @access public
	 * @return void
	 */
	function {/literal}{$type.class_name}{literal}( $p{/literal}{$type.name|capitalize}{literal}Id=NULL, $pContentId=NULL ) {
		{/literal}{$type.base_class}::{$type.base_class}();{literal}
		$this->m{/literal}{$type.name|capitalize}{literal}Id = $p{/literal}{$type.name|capitalize}{literal}Id;
		$this->mContentId = $pContentId;
		$this->mContentTypeGuid = BIT{/literal}{$type.name|upper}{literal}_CONTENT_TYPE_GUID;
		$this->registerContentType( BIT{/literal}{$type.name|upper}{literal}_CONTENT_TYPE_GUID, array(
			'content_type_guid'	  => BIT{/literal}{$type.name|upper}{literal}_CONTENT_TYPE_GUID,
{/literal}{if $type.content_name}
			'content_name' => '{$type.content_name}',
{else}
			'content_name' => '{$type.name|capitalize} data',
{/if}
{if $type.content_name_plural}
			'content_name_plural' => '{$type.content_name_plural}',
{/if}{literal}			'handler_class'		  => '{/literal}{$type.class_name}{literal}',
			'handler_package'	  => '{/literal}{$package}{literal}',
			'handler_file'		  => '{/literal}{$type.class_name}{literal}.php',
{/literal}{if !empty($config.maintainer_url)}
			'maintainer_url'	  => '{$config.maintainer_url}'
{else}
			'maintainer_url'	  => 'http://www.bitweaver.org'
{/if}{literal}		));
		// Permission setup
		$this->mCreateContentPerm  = 'p_{/literal}{$type.name|lower}{literal}_create';
		$this->mViewContentPerm	   = 'p_{/literal}{$type.name|lower}{literal}_view';
		$this->mUpdateContentPerm  = 'p_{/literal}{$type.name|lower}{literal}_update';
		$this->mExpungeContentPerm = 'p_{/literal}{$type.name|lower}{literal}_expunge';
		$this->mAdminContentPerm   = 'p_{/literal}{$package}{literal}_admin';
	}

	/**
	 * load Load the data from the database
	 * 
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function load() {
		if( $this->verifyId( $this->m{/literal}{$type.name|capitalize}{literal}Id ) || $this->verifyId( $this->mContentId ) ) {
			// LibertyContent::load()assumes you have joined already, and will not execute any sql!
			// This is a significant performance optimization
			$lookupColumn = $this->verifyId( $this->m{/literal}{$type.name|capitalize}{literal}Id ) ? '{/literal}{$type.name|lower}{literal}_id' : 'content_id';
			$bindVars = array();
			$selectSql = $joinSql = $whereSql = '';
			array_push( $bindVars, $lookupId = @BitBase::verifyId( $this->m{/literal}{$type.name|capitalize}{literal}Id ) ? $this->m{/literal}{$type.name|capitalize}{literal}Id : $this->mContentId );
			$this->getServicesSql( 'content_load_sql_function', $selectSql, $joinSql, $whereSql, $bindVars );

			$query = "
				SELECT {/literal}{$type.name|lower}{literal}.*, lc.*,
				uue.`login` AS modifier_user, uue.`real_name` AS modifier_real_name,
				uuc.`login` AS creator_user, uuc.`real_name` AS creator_real_name,
				lch.`hits`,
				lf.`storage_path` as avatar,
				lfp.storage_path AS `primary_attachment_path`
				$selectSql
				FROM `".BIT_DB_PREFIX."{/literal}{$type.name|lower}{literal}_data` {/literal}{$type.name|lower}{literal}
					INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {/literal}{$type.name|lower}{literal}.`content_id` ) $joinSql
					LEFT JOIN `".BIT_DB_PREFIX."users_users` uue ON( uue.`user_id` = lc.`modifier_user_id` )
					LEFT JOIN `".BIT_DB_PREFIX."users_users` uuc ON( uuc.`user_id` = lc.`user_id` )
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_content_hits` lch ON( lch.`content_id` = lc.`content_id` )
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_attachments` a ON (uue.`user_id` = a.`user_id` AND uue.`avatar_attachment_id`=a.`attachment_id`)
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_files` lf ON (lf.`file_id` = a.`foreign_id`)
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_attachments` la ON( la.`content_id` = lc.`content_id` AND la.`is_primary` = 'y' )
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_files` lfp ON( lfp.`file_id` = la.`foreign_id` )
				WHERE {/literal}{$type.name|lower}{literal}.`$lookupColumn`=? $whereSql";
			$result = $this->mDb->query( $query, $bindVars );

			if( $result && $result->numRows() ) {
				$this->mInfo = $result->fields;
				$this->mContentId = $result->fields['content_id'];
{/literal}{if count($type.typemaps) > 0}
				// Load any typemaps
				$this->loadTypemaps();
{/if}{literal}
				$this->m{/literal}{$type.name|capitalize}{literal}Id = $result->fields['{/literal}{$type.name|lower}{literal}_id'];

				$this->mInfo['creator'] = ( !empty( $result->fields['creator_real_name'] ) ? $result->fields['creator_real_name'] : $result->fields['creator_user'] );
				$this->mInfo['editor'] = ( !empty( $result->fields['modifier_real_name'] ) ? $result->fields['modifier_real_name'] : $result->fields['modifier_user'] );
				$this->mInfo['display_name'] = BitUser::getTitle( $this->mInfo );
				$this->mInfo['display_url'] = $this->getDisplayUrl();
				$this->mInfo['parsed_data'] = $this->parseData();

				{/literal}{$type.base_class}{literal}::load();
			}
		}
		return( count( $this->mInfo ) );
	}

	/**
	* Deal with text and images, modify them apprpriately that they can be returned to the form.
	* @param $pParamHash data submitted by form - generally $_REQUEST
	* @return array of data compatible with edit form
	* @access public
	**/
	function preparePreview( &$pParamHash ){
		global $gBitSystem, $gBitUser;

		if( empty( $this->mInfo['user_id'] ) ) {
			$this->mInfo['user_id'] = $gBitUser->mUserId;
			$this->mInfo['creator_user'] = $gBitUser->getField( 'login' );
			$this->mInfo['creator_real_name'] = $gBitUser->getField( 'real_name' );
		}

		$this->mInfo['creator_user_id'] = $this->mInfo['user_id'];

		if( empty( $this->mInfo['created'] ) ){
			$this->mInfo['created'] = $gBitSystem->getUTCTime();
		}

		$this->previewFields($pParamHash);

{/literal}{if count($type.typemaps) > 0}
		// Preview any typemaps
		$this->previewTypemaps($pParamHash);
{/if}{literal}

		// Liberty should really have a preview function that handles these
		// But it doesn't so we handle them here.
		if( isset( $pParamHash['{/literal}{$type.name}{literal}']["title"] ) ) {
			$this->mInfo["title"] = $pParamHash['{/literal}{$type.name}{literal}']["title"];
		}

		if( isset( $pParamHash['{/literal}{$type.name}{literal}']["summary"] ) ) {
			$this->mInfo["summary"] = $pParamHash['{/literal}{$type.name}{literal}']["summary"];
		}

		if( isset( $pParamHash['{/literal}{$type.name}{literal}']["format_guid"] ) ) {
			$this->mInfo['format_guid'] = $pParamHash['{/literal}{$type.name}{literal}']["format_guid"];
		}

		if( isset( $pParamHash["group"]["edit"] ) ) {
			$this->mInfo["data"] = $pParamHash["group"]["edit"];
			$this->mInfo['parsed_data'] = $this->parseData();
		}
	}

	/**
	 * store Any method named Store inherently implies data will be written to the database
	 * @param pParamHash be sure to pass by reference in case we need to make modifcations to the hash
	 * This is the ONLY method that should be called in order to store( create or update )an {/literal}{$type.name|lower}{literal}!
	 * It is very smart and will figure out what to do for you. It should be considered a black box.
	 *
	 * @param array $pParamHash hash of values that will be used to store the page
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function store( &$pParamHash ) {
		if( $this->verify( $pParamHash )
{/literal}{if count($type.typemaps) > 0}
			&& $this->verifyTypemaps( $pParamHash )
{/if}{literal}
			&& {/literal}{$type.base_class}{literal}::store( $pParamHash['{/literal}{$type.name}{literal}'] ) ) {
			$this->mDb->StartTrans();
			$table = BIT_DB_PREFIX."{/literal}{$type.name|lower}{literal}_data";
			if( $this->m{/literal}{$type.name|capitalize}{literal}Id ) {
				$locId = array( "{/literal}{$type.name|lower}{literal}_id" => $pParamHash['{/literal}{$type.name}{literal}']['{/literal}{$type.name|lower}{literal}_id'] );
				$result = $this->mDb->associateUpdate( $table, $pParamHash['{/literal}{$type.name|lower}{literal}_store'], $locId );
			} else {
				$pParamHash['{/literal}{$type.name|lower}{literal}_store']['content_id'] = $pParamHash['{/literal}{$type.name}{literal}']['content_id'];
				if( @$this->verifyId( $pParamHash['{/literal}{$type.name|lower}{literal}_id'] ) ) {
					// if pParamHash['{/literal}{$type.name}{literal}']['{/literal}{$type.name|lower}{literal}_id'] is set, some is requesting a particular {/literal}{$type.name|lower}{literal}_id. Use with caution!
					$pParamHash['{/literal}{$type.name|lower}{literal}_store']['{/literal}{$type.name|lower}{literal}_id'] = $pParamHash['{/literal}{$type.name}{literal}']['{/literal}{$type.name|lower}{literal}_id'];
				} else {
					$pParamHash['{/literal}{$type.name|lower}{literal}_store']['{/literal}{$type.name|lower}{literal}_id'] = $this->mDb->GenID( '{/literal}{$type.name|lower}{literal}_data_id_seq' );
				}
				$this->m{/literal}{$type.name|capitalize}{literal}Id = $pParamHash['{/literal}{$type.name|lower}{literal}_store']['{/literal}{$type.name|lower}{literal}_id'];

				$result = $this->mDb->associateInsert( $table, $pParamHash['{/literal}{$type.name|lower}{literal}_store'] );
			}

{/literal}{if count($type.typemaps) > 0}
			$this->storeTypemaps( $pParamHash );
{/if}{literal}
{/literal}
			/* =-=- CUSTOM BEGIN: store -=-= */
{if !empty($customBlock.store)}
{$customBlock.store}
{else}

{/if}
			/* =-=- CUSTOM END: store -=-= */
{literal}

			$this->mDb->CompleteTrans();
			$this->load();
		} else {
			$this->mErrors['store'] = tra('Failed to save this').' {/literal}{$type.name|lower}{literal}.';
		}

		return( count( $this->mErrors )== 0 );
	}

	/**
	 * verify Make sure the data is safe to store
	 * @param pParamHash be sure to pass by reference in case we need to make modifcations to the hash
	 * This function is responsible for data integrity and validation before any operations are performed with the $pParamHash
	 * NOTE: This is a PRIVATE METHOD!!!! do not call outside this class, under penalty of death!
	 *
	 * @param array $pParamHash reference to hash of values that will be used to store the page, they will be modified where necessary
	 * @access private
	 * @return boolean TRUE on success, FALSE on failure - $this->mErrors will contain reason for failure
	 */
	function verify( &$pParamHash ) {
		// make sure we're all loaded up of we have a m{/literal}{$type.name|capitalize}{literal}Id
		if( $this->verifyId( $this->m{/literal}{$type.name|capitalize}{literal}Id ) && empty( $this->mInfo ) ) {
			$this->load();
		}

		if( @$this->verifyId( $this->mInfo['content_id'] ) ) {
			$pParamHash['{/literal}{$type.name}{literal}']['content_id'] = $this->mInfo['content_id'];
		}

		// It is possible a derived class set this to something different
		if( @$this->verifyId( $pParamHash['{/literal}{$type.name}{literal}']['content_type_guid'] ) ) {
			$pParamHash['{/literal}{$type.name}{literal}']['content_type_guid'] = $this->mContentTypeGuid;
		}

		if( @$this->verifyId( $pParamHash['{/literal}{$type.name}{literal}']['content_id'] ) ) {
			$pParamHash['{/literal}{$type.name}{literal}']['{/literal}{$type.name|lower}{literal}_store']['content_id'] = $pParamHash['{/literal}{$type.name}{literal}']['content_id'];
		}

		// Use $pParamHash here since it handles validation right
		$this->validateFields($pParamHash);

		if( !empty( $pParamHash['{/literal}{$type.name}{literal}']['data'] ) ) {
			$pParamHash['{/literal}{$type.name}{literal}']['edit'] = $pParamHash['{/literal}{$type.name}{literal}']['data'];
		}

		// If title specified truncate to make sure not too long
		// TODO: This shouldn't be required. LC should validate this.
		if( !empty( $pParamHash['{/literal}{$type.name}{literal}']['title'] ) ) {
			$pParamHash['{/literal}{$type.name}{literal}']['content_store']['title'] = substr( $pParamHash['{/literal}{$type.name}{literal}']['title'], 0, 160 );
		} else if( empty( $pParamHash['{/literal}{$type.name}{literal}']['title'] ) ) { // else is error as must have title
			$this->mErrors['title'] = tra('You must enter a title for this').' {/literal}{$type.name|lower}{literal}.';
		}

{/literal}
		/* =-=- CUSTOM BEGIN: verify -=-= */
{if !empty($customBlock.verify)}
{$customBlock.verify}
{else}

{/if}
		/* =-=- CUSTOM END: verify -=-= */
{literal}

		// if we have an error we get them all by checking parent classes for additional errors and the typeMaps if there are any
		if( count( $this->mErrors ) > 0 ){
			// check errors of base class so we get them all in one go
			{/literal}{$type.base_class}{literal}::verify( $pParamHash['{/literal}{$type.name}{literal}'] );
{/literal}{if count($type.typemaps) > 0}
			// And now check the typemaps
			$this->verifyTypemaps( $pParamHash );
{/if}{literal}
		}

		return( count( $this->mErrors )== 0 );
	}

	/**
	 * expunge
	 *
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure
	 */
	function expunge() {
		global $gBitSystem;
		$ret = FALSE;
		if( $this->isValid() ) {
			$this->mDb->StartTrans();

{/literal}
			/* =-=- CUSTOM BEGIN: expunge -=-= */
{if !empty($customBlock.expunge)}
{$customBlock.expunge}
{else}

{/if}
			/* =-=- CUSTOM END: expunge -=-= */
{literal}
{/literal}{if count($type.typemaps) > 0}
			// Expunge any typemaps
			$this->expungeTypemaps();
{/if}{literal}

			$query = "DELETE FROM `".BIT_DB_PREFIX."{/literal}{$type.name|lower}{literal}_data` WHERE `content_id` = ?";
			$result = $this->mDb->query( $query, array( $this->mContentId ) );
			if( {/literal}{$type.base_class}{literal}::expunge() ) {
				$ret = TRUE;
			}
			$this->mDb->CompleteTrans();
			// If deleting the default/home {/literal}{$type.name|lower}{literal} record then unset this.
			if( $ret && $gBitSystem->getConfig( '{/literal}{$type.name|lower}{literal}_home_id' ) == $this->m{/literal}{$type.name|capitalize}{literal}Id ) {
				$gBitSystem->storeConfig( '{/literal}{$type.name|lower}{literal}_home_id', 0, {/literal}{$type.name|upper}{literal}_PKG_NAME );
			}
		}
		return $ret;
	}

{/literal}
{literal}

	/**
	 * isValid Make sure {/literal}{$type.name|lower}{literal} is loaded and valid
	 * 
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure
	 */
	function isValid() {
		return( @BitBase::verifyId( $this->m{/literal}{$type.name|capitalize}{literal}Id ) && @BitBase::verifyId( $this->mContentId ));
	}

	/**
	 * getList This function generates a list of records from the liberty_content database for use in a list page
	 *
	 * @param array $pParamHash
	 * @access public
	 * @return array List of {/literal}{$type.name|lower}{literal} data
	 */
	function getList( &$pParamHash ) {
		// this makes sure parameters used later on are set
		LibertyContent::prepGetList( $pParamHash );

		$selectSql = $joinSql = $whereSql = '';
		$bindVars = array();
		array_push( $bindVars, $this->mContentTypeGuid );
		$this->getServicesSql( 'content_list_sql_function', $selectSql, $joinSql, $whereSql, $bindVars );

{/literal}
		/* =-=- CUSTOM BEGIN: getList -=-= */
{if !empty($customBlock.getList)}
{$customBlock.getList}
{else}

{/if}
		/* =-=- CUSTOM END: getList -=-= */
{literal}

		// this will set $find, $sort_mode, $max_records and $offset
		extract( $pParamHash );

		if( is_array( $find ) ) {
			// you can use an array of pages
			$whereSql .= " AND lc.`title` IN( ".implode( ',',array_fill( 0,count( $find ),'?' ) )." )";
			$bindVars = array_merge ( $bindVars, $find );
		} elseif( is_string( $find ) ) {
			// or a string
			$whereSql .= " AND UPPER( lc.`title` )like ? ";
			$bindVars[] = '%' . strtoupper( $find ). '%';
		}

		$query = "
			SELECT {/literal}{$type.name|lower}{literal}.*, lc.`content_id`, lc.`title`, lc.`data` $selectSql
			FROM `".BIT_DB_PREFIX."{/literal}{$type.name|lower}{literal}_data` {/literal}{$type.name|lower}{literal}
				INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {/literal}{$type.name|lower}{literal}.`content_id` ) $joinSql
			WHERE lc.`content_type_guid` = ? $whereSql
			ORDER BY ".$this->mDb->convertSortmode( $sort_mode );
		$query_cant = "
			SELECT COUNT(*)
			FROM `".BIT_DB_PREFIX."{/literal}{$type.name|lower}{literal}_data` {/literal}{$type.name|lower}{literal}
				INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {/literal}{$type.name|lower}{literal}.`content_id` ) $joinSql
			WHERE lc.`content_type_guid` = ? $whereSql";
		$result = $this->mDb->query( $query, $bindVars, $max_records, $offset );
		$ret = array();
		while( $res = $result->fetchRow() ) {
			$ret[] = $res;
		}
		$pParamHash["cant"] = $this->mDb->getOne( $query_cant, $bindVars );

		// add all pagination info to pParamHash
		LibertyContent::postGetList( $pParamHash );
		return $ret;
	}

	/**
	 * getDisplayUrl Generates the URL to the {/literal}{$type.name|lower}{literal} page
	 * 
	 * @access public
	 * @return string URL to the {/literal}{$type.name|lower}{literal} page
	 */
	function getDisplayUrl() {
		global $gBitSystem;
		$ret = NULL;
		if( @$this->isValid() ) {
			if( $gBitSystem->isFeatureActive( 'pretty_urls' ) || $gBitSystem->isFeatureActive( 'pretty_urls_extended' )) {
				$ret = {/literal}{$PACKAGE}_PKG_URL.'{if empty($type.rewrite_path)}{$type.name}{else}{$type.rewrite_path}{/if}/'.$this->m{$type.name|capitalize}{literal}Id;
			} else {
				$ret = {/literal}{$PACKAGE}{literal}_PKG_URL."index.php?{/literal}{$type.name|lower}{literal}_id=".$this->m{/literal}{$type.name|capitalize}{literal}Id;
			}
		}
		return $ret;
	}

	/**
	 * previewFields prepares the fields in this type for preview
	 */
	function previewFields(&$pParamHash) {
		$this->prepVerify();
		LibertyValidator::preview(
		$this->mVerification['{/literal}{$type.name}_data{literal}'],
			$pParamHash['{/literal}{$type.name}{literal}'],
			$this->mInfo);
	}

	/**
	 * validateFields validates the fields in this type
	 */
	function validateFields(&$pParamHash) {
		$this->prepVerify();
		LibertyValidator::validate(
			$this->mVerification['{/literal}{$type.name}_data{literal}'],
			$pParamHash['{/literal}{$type.name}{literal}'],
			$this, $pParamHash['{/literal}{$type.name}{literal}_store']);
	}

	/**
	 * prepVerify prepares the object for input verification
	 */
	function prepVerify() {
		if (empty($this->mVerification['{/literal}{$type.name}{literal}_data'])) {
{/literal}
{foreach from=$type.fields key=fieldName item=field name=fields}
	 		/* Validation for {$fieldName} */
{if !empty($field.validator.type) && $field.validator.type != "no-input"}
			$this->mVerification['{$type.name}_data']['{$field.validator.type}']['{$fieldName}'] = array(
                               'name' => '{$fieldName}',
{foreach from=$field.validator key=k item=v name=keys}
{if $k != 'type'}
				'{$k}' => {if is_array($v)}array(
{foreach from=$v key=vk item=vv name=values}
					{if is_numeric($vk)}{$vk}{else}'{$vk}'{/if} => '{$vv}'{if !$smarty.foreach.values.last},{/if}

{/foreach}
					){else}'{$v}'{/if}{if !$smarty.foreach.keys.last},{/if}

{/if}
{/foreach}
			);
{elseif empty($field.validator.type)}
	$this->mVerification['{$type.name}_data']['null']['{$fieldName}'] = TRUE;
{/if}
{/foreach}
{literal}
{/literal}{foreach from=$type.typemaps key=typemapName item=typemap}
		// prepVerify {$typemapName} fieldset
		$this->prep{$typemapName|ucfirst}Verify();
{/foreach}{literal}
		}
	}

{/literal}
	// Getters for reference column options - return associative arrays formatted for generating html select inputs
{foreach from=$type.fields key=fieldName item=field}
{if $field.validator.input == 'select'}
	function get{$field.name|replace:" ":""}Options(){ldelim}
		return $this->mDb->getAssoc("{$field.validator.optionsHashQuery}");
	{rdelim}

{/if}{/foreach}
{literal}
{/literal}

{if count($type.typemaps) > 0}{literal}
	// {{{ =================== TypeMap Functions for FieldSets ====================

	function verifyTypemaps( &$pParamHash ) {
{/literal}{foreach from=$type.typemaps key=typemapName item=typemap}
			// verify {$typemapName} fieldset
			$this->verify{$typemapName|ucfirst}($pParamHash);
{/foreach}{literal}

			return ( count($this->mErrors) == 0);
	}

	function previewTypemaps( &$pParamHash ) {
{/literal}{foreach from=$type.typemaps key=typemapName item=typemap}
			// verify {$typemapName} fieldset
			$this->preview{$typemapName|ucfirst}Fields($pParamHash);
{/foreach}{literal}
	}

	function storeTypemaps( &$pParamHash ) {
{/literal}{foreach from=$type.typemaps key=typemapName item=typemap}
			// store {$typemapName} fieldset
			$this->store{$typemapName|ucfirst}Mixed($pParamHash, TRUE);
{/foreach}{literal}
	}

	function expungeTypemaps() {
		if ($this->isValid() ) {
			$paramHash = array('content_id' => $this->mContentId);
{/literal}{foreach from=$type.typemaps key=typemapName item=typemap}
			// expunge {$typemapName} fieldset
			$this->expunge{$typemapName|ucfirst}($paramHash);
{/foreach}{literal}
		}
	}

	function loadTypemaps() {
{/literal}{foreach from=$type.typemaps key=typemapName item=typemap}
			// load {$typemapName} list from sub map
			$this->mInfo['{$typemapName}'] = $this->list{$typemapName|ucfirst}();
{/foreach}{literal}
	}

	// }}} -- end of TypeMap function for fieldsets
{/literal}
{foreach from=$type.typemaps key=typemapName item=typemap}
{include file="bitpackage:pkgmkr/typemap_methods_inc.php.tpl"}
{/foreach}
{/if}{literal}

	// {{{ =================== Custom Helper Mthods  ====================
{/literal}
	/* This section is for any helper methods you wish to create */
	/* =-=- CUSTOM BEGIN: methods -=-= */
{if !empty($customBlock.methods)}
{$customBlock.methods}
{else}

{/if}
	/* =-=- CUSTOM END: methods -=-= */
{literal}
	// }}} -- end of Custom Helper Methods
}
{/literal}
