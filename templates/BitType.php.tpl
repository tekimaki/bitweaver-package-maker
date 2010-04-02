{literal}<?php
/**
 * $Header: $
 *
 * Copyright (c) 2010 bitweaver.org
 * Copyright (c) 2010 nick palmer@overtsolutions.com
 *
 * All Rights Reserved. See below for details and a complete list of authors.
 * Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details
 *
 * $Id: $
 * @package {/literal}{$package|lower}{literal}
 * @subpackage class
 */

/**
* {/literal}{$render.class_name}{literal} class
* {/literal}{$render.description}{literal}
*
* Generated On: {/literal}{$smarty.now|date_format}{literal}
* @version $Revision: $
* @class {/literal}{$render.class_name}{literal}
*/

require_once( {/literal}{$render.base_package|upper}{literal}_PKG_PATH.'{/literal}{$render.base_class}{literal}.php' );

/**
* This is used to uniquely identify the object
*/
define( 'BIT{/literal}{$render.class|upper}{literal}_CONTENT_TYPE_GUID', 'bit{/literal}{$render.class|lower}{literal}' );

class {/literal}{$render.class_name}{literal} extends {/literal}{$render.base_class}{literal} {
	/**
	 * m{/literal}{$render.class|capitalize}{literal}Id Primary key for our mythical {/literal}{$render.class|capitalize}{literal} class object & table
	 * 
	 * @var array
	 * @access public
	 */
	var $m{/literal}{$render.class|capitalize}{literal}Id;

	/**
	 * {/literal}{$render.class_name}{literal} During initialisation, be sure to call our base constructors
	 * 
	 * @param numeric $p{/literal}{$render.class|capitalize}{literal}Id 
	 * @param numeric $pContentId 
	 * @access public
	 * @return void
	 */
	function {/literal}{$render.class_name}{literal}( $p{/literal}{$render.class|capitalize}{literal}Id=NULL, $pContentId=NULL ) {
		{/literal}{$render.base_class}::{$render.base_class}();{literal}
		$this->m{/literal}{$render.class|capitalize}{literal}Id = $p{/literal}{$render.class|capitalize}{literal}Id;
		$this->mContentId = $pContentId;
		$this->mContentTypeGuid = BIT{/literal}{$render.class|upper}{literal}_CONTENT_TYPE_GUID;
		$this->registerContentType( BIT{/literal}{$render.class|upper}{literal}_CONTENT_TYPE_GUID, array(
			'content_type_guid'   => BIT{/literal}{$render.class|upper}{literal}_CONTENT_TYPE_GUID,
{/literal}{if !empty($render.content_description)}
			'content_description' => '{$render.content_description}',
{else}
			'content_description' => '{$render.class|capitalize} data',
{/if}{literal}			'handler_class'       => '{/literal}{$render.class_name|capitalize}{literal}',
			'handler_package'     => '{/literal}{$package}{literal}',
			'handler_file'        => '{/literal}{$render.class_name}{literal}.php',
{/literal}{if !empty($render.maintainer_url)}
			'maintainer_url'      => '{$render.maintainer_url}'
{else}
			'maintainer_url'      => 'http://www.bitweaver.org'
{/if}{literal}		));
		// Permission setup
		$this->mAdminContentPerm   = 'p_{/literal}{$package}{literal}_admin';
		$this->mViewContentPerm    = 'p_{/literal}{$render.class|lower}{literal}_view';
		$this->mCreateContentPerm  = 'p_{/literal}{$render.class|lower}{literal}_create';
		$this->mUpdateContentPerm  = 'p_{/literal}{$render.class|lower}{literal}_update';
		$this->mExpungeContentPerm = 'p_{/literal}{$render.class|lower}{literal}_expunge';
	}

	/**
	 * load Load the data from the database
	 * 
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function load() {
		if( $this->verifyId( $this->m{/literal}{$render.class|capitalize}{literal}Id ) || $this->verifyId( $this->mContentId ) ) {
			// LibertyContent::load()assumes you have joined already, and will not execute any sql!
			// This is a significant performance optimization
			$lookupColumn = $this->verifyId( $this->m{/literal}{$render.class|capitalize}{literal}Id ) ? '{/literal}{$render.class|lower}{literal}_id' : 'content_id';
			$bindVars = array();
			$selectSql = $joinSql = $whereSql = '';
			array_push( $bindVars, $lookupId = @BitBase::verifyId( $this->m{/literal}{$render.class|capitalize}{literal}Id ) ? $this->m{/literal}{$render.class|capitalize}{literal}Id : $this->mContentId );
			$this->getServicesSql( 'content_load_sql_function', $selectSql, $joinSql, $whereSql, $bindVars );

			$query = "
				SELECT {/literal}{$render.class|lower}{literal}.*, lc.*,
				uue.`login` AS modifier_user, uue.`real_name` AS modifier_real_name,
				uuc.`login` AS creator_user, uuc.`real_name` AS creator_real_name
				$selectSql
				FROM `".BIT_DB_PREFIX."{/literal}{$render.class|lower}{literal}_data` {/literal}{$render.class|lower}{literal}
					INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {/literal}{$render.class|lower}{literal}.`content_id` ) $joinSql
					LEFT JOIN `".BIT_DB_PREFIX."users_users` uue ON( uue.`user_id` = lc.`modifier_user_id` )
					LEFT JOIN `".BIT_DB_PREFIX."users_users` uuc ON( uuc.`user_id` = lc.`user_id` )
				WHERE {/literal}{$render.class|lower}{literal}.`$lookupColumn`=? $whereSql";
			$result = $this->mDb->query( $query, $bindVars );

			if( $result && $result->numRows() ) {
				$this->mInfo = $result->fields;
				$this->mContentId = $result->fields['content_id'];
				$this->m{/literal}{$render.class|capitalize}{literal}Id = $result->fields['{/literal}{$render.class|lower}{literal}_id'];

				$this->mInfo['creator'] = ( !empty( $result->fields['creator_real_name'] ) ? $result->fields['creator_real_name'] : $result->fields['creator_user'] );
				$this->mInfo['editor'] = ( !empty( $result->fields['modifier_real_name'] ) ? $result->fields['modifier_real_name'] : $result->fields['modifier_user'] );
				$this->mInfo['display_name'] = BitUser::getTitle( $this->mInfo );
				$this->mInfo['display_url'] = $this->getDisplayUrl();
				$this->mInfo['parsed_data'] = $this->parseData();

				LibertyMime::load();
			}
		}
		return( count( $this->mInfo ) );
	}

	/**
	 * store Any method named Store inherently implies data will be written to the database
	 * @param pParamHash be sure to pass by reference in case we need to make modifcations to the hash
	 * This is the ONLY method that should be called in order to store( create or update )an {/literal}{$render.class|lower}{literal}!
	 * It is very smart and will figure out what to do for you. It should be considered a black box.
	 * 
	 * @param array $pParamHash hash of values that will be used to store the page
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function store( &$pParamHash ) {
		if( $this->verify( $pParamHash )&& LibertyMime::store( $pParamHash ) ) {
			$this->mDb->StartTrans();
			$table = BIT_DB_PREFIX."{/literal}{$render.class|lower}{literal}_data";
			if( $this->m{/literal}{$render.class|capitalize}{literal}Id ) {
				$locId = array( "{/literal}{$render.class|lower}{literal}_id" => $pParamHash['{/literal}{$render.class|lower}{literal}_id'] );
				$result = $this->mDb->associateUpdate( $table, $pParamHash['{/literal}{$render.class|lower}{literal}_store'], $locId );
			} else {
				$pParamHash['{/literal}{$render.class|lower}{literal}_store']['content_id'] = $pParamHash['content_id'];
				if( @$this->verifyId( $pParamHash['{/literal}{$render.class|lower}{literal}_id'] ) ) {
					// if pParamHash['{/literal}{$render.class|lower}{literal}_id'] is set, some is requesting a particular {/literal}{$render.class|lower}{literal}_id. Use with caution!
					$pParamHash['{/literal}{$render.class|lower}{literal}_store']['{/literal}{$render.class|lower}{literal}_id'] = $pParamHash['{/literal}{$render.class|lower}{literal}_id'];
				} else {
					$pParamHash['{/literal}{$render.class|lower}{literal}_store']['{/literal}{$render.class|lower}{literal}_id'] = $this->mDb->GenID( '{/literal}{$render.class|lower}{literal}_data_id_seq' );
				}
				$this->m{/literal}{$render.class|capitalize}{literal}Id = $pParamHash['{/literal}{$render.class|lower}{literal}_store']['{/literal}{$render.class|lower}{literal}_id'];

				$result = $this->mDb->associateInsert( $table, $pParamHash['{/literal}{$render.class|lower}{literal}_store'] );
			}

			$this->mDb->CompleteTrans();
			$this->load();
		} else {
			$this->mErrors['store'] = 'Failed to save this {/literal}{$render.class|lower}{literal}.';
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
		// make sure we're all loaded up of we have a m{/literal}{$render.class|capitalize}{literal}Id
		if( $this->verifyId( $this->m{/literal}{$render.class|capitalize}{literal}Id ) && empty( $this->mInfo ) ) {
			$this->load();
		}

		if( @$this->verifyId( $this->mInfo['content_id'] ) ) {
			$pParamHash['content_id'] = $this->mInfo['content_id'];
		}

		// It is possible a derived class set this to something different
		if( @$this->verifyId( $pParamHash['content_type_guid'] ) ) {
			$pParamHash['content_type_guid'] = $this->mContentTypeGuid;
		}

		if( @$this->verifyId( $pParamHash['content_id'] ) ) {
			$pParamHash['{/literal}{$render.class|lower}{literal}_store']['content_id'] = $pParamHash['content_id'];
		}

		$this->validateFields($pParamHash);

		if( !empty( $pParamHash['data'] ) ) {
			$pParamHash['edit'] = $pParamHash['data'];
		}

		// If title specified truncate to make sure not too long
		if( !empty( $pParamHash['title'] ) ) {
			$pParamHash['content_store']['title'] = substr( $pParamHash['title'], 0, 160 );
		} else if( empty( $pParamHash['title'] ) ) { // else is error as must have title
			$this->mErrors['title'] = 'You must enter a title for this {/literal}{$render.class|lower}{literal}.';
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
			$query = "DELETE FROM `".BIT_DB_PREFIX."{/literal}{$render.class|lower}{literal}_data` WHERE `content_id` = ?";
			$result = $this->mDb->query( $query, array( $this->mContentId ) );
			if( LibertyMime::expunge() ) {
				$ret = TRUE;
			}
			$this->mDb->CompleteTrans();
			// If deleting the default/home {/literal}{$render.class|lower}{literal} record then unset this.
			if( $ret && $gBitSystem->getConfig( '{/literal}{$render.class|lower}{literal}_home_id' ) == $this->m{/literal}{$render.class|capitalize}{literal}Id ) {
				$gBitSystem->storeConfig( '{/literal}{$render.class|lower}{literal}_home_id', 0, {/literal}{$render.class|upper}{literal}_PKG_NAME );
			}
		}
		return $ret;
	}

	/**
	 * isValid Make sure {/literal}{$render.class|lower}{literal} is loaded and valid
	 * 
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure
	 */
	function isValid() {
		return( @BitBase::verifyId( $this->m{/literal}{$render.class|capitalize}{literal}Id ) && @BitBase::verifyId( $this->mContentId ));
	}

	/**
	 * getList This function generates a list of records from the liberty_content database for use in a list page
	 * 
	 * @param array $pParamHash 
	 * @access public
	 * @return array List of {/literal}{$render.class|lower}{literal} data
	 */
	function getList( &$pParamHash ) {
		// this makes sure parameters used later on are set
		LibertyContent::prepGetList( $pParamHash );

		$selectSql = $joinSql = $whereSql = '';
		$bindVars = array();
		array_push( $bindVars, $this->mContentTypeGuid );
		$this->getServicesSql( 'content_list_sql_function', $selectSql, $joinSql, $whereSql, $bindVars );

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
			SELECT {/literal}{$render.class|lower}{literal}.*, lc.`content_id`, lc.`title`, lc.`data` $selectSql
			FROM `".BIT_DB_PREFIX."{/literal}{$render.class|lower}{literal}_data` {/literal}{$render.class|lower}{literal}
				INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {/literal}{$render.class|lower}{literal}.`content_id` ) $joinSql
			WHERE lc.`content_type_guid` = ? $whereSql
			ORDER BY ".$this->mDb->convertSortmode( $sort_mode );
		$query_cant = "
			SELECT COUNT(*)
			FROM `".BIT_DB_PREFIX."{/literal}{$render.class|lower}{literal}_data` {/literal}{$render.class|lower}{literal}
				INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {/literal}{$render.class|lower}{literal}.`content_id` ) $joinSql
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
	 * getDisplayUrl Generates the URL to the {/literal}{$render.class|lower}{literal} page
	 * 
	 * @access public
	 * @return string URL to the {/literal}{$render.class|lower}{literal} page
	 */
	function getDisplayUrl() {
		global $gBitSystem;
		$ret = NULL;
		if( @$this->isValid() ) {
			if( $gBitSystem->isFeatureActive( 'pretty_urls' ) || $gBitSystem->isFeatureActive( 'pretty_urls_extended' )) {
				$ret = {/literal}{$render.class|upper}{literal}_PKG_URL.$this->m{/literal}{$render.class|capitalize}{literal}Id;
			} else {
				$ret = {/literal}{$render.class|upper}{literal}_PKG_URL."index.php?{/literal}{$render.class|lower}{literal}_id=".$this->m{/literal}{$render.class|capitalize}{literal}Id;
			}
		}
		return $ret;
	}

	/**
	 * previewFields prepares the fields in this type for preview
	 */
	function previewFields($pParamHash) {
		prepVerify();
		LibertyValidator::preview(
			$this->mVerification,
			$pParamHash[{/literal}{$render.class}{literal}],
			$pParamHash['{/literal}{$render.class}{literal}_store']);
	}

	/**
	 * validateFields validates the fields in this type
	 */
	function validateFields($pParamHash) {
		prepVerify();
		LibertyValidator::validate(
			$this->mVerification,
			$pParamHash[{/literal}{$render.class}{literal}],
			$this, $pParamHash['{/literal}{$render.class}{literal}_store']);
	}

	/**
	 * prepVerify prepares the object for input verification
	 */
	function prepVerify() {
		if (empty($this->mVerification)) {
{/literal}
{foreach from=$render.fields key=fieldName item=field name=fields}
	 		/* Validation for {$fieldName} */
{if !empty($field.validator)}
			$this->mVerification['{$field.validator.type}']['{$fieldName}'] = array(
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
{else}
			$this->mVerification['null']['{$fieldName}'] = TRUE;
{/if}
{/foreach}
{literal}
		}
	}
}
{/literal}
