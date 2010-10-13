<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim: :set fdm=marker : */
{{include file="php_file_header.tpl"}}
/**
* {{$type.class_name}} class
* {{$type.description}}
*
* @version $Revision: $
* @class {{$type.class_name}}
*/

/**
 * Initialize
 */
require_once( {{$type.base_package|upper}}_PKG_PATH.'{{$type.base_class}}.php' );
require_once( LIBERTY_PKG_PATH . 'LibertyValidator.php' );

/* =-=- CUSTOM BEGIN: require -=-= */
{{if !empty($customBlock.require)}}
{{$customBlock.require}}
{{else}}

{{/if}}
/* =-=- CUSTOM END: require -=-= */


/**
* This is used to uniquely identify the object
*/
define( 'BIT{{$type.name|upper}}_CONTENT_TYPE_GUID', 'bit{{$type.name|lower}}' );

class {{$type.class_name}} extends {{$type.base_class}} {
	/**
	 * m{{$type.name|capitalize}}Id Primary key for our {{$type.name|capitalize}} class object & table
	 *
	 * @var array
	 * @access public
	 */
	var $m{{$type.name|capitalize}}Id;

	var $mVerification;

	var $mSchema;

	/**
	 * {{$type.class_name}} During initialisation, be sure to call our base constructors
	 *
	 * @param numeric $p{{$type.name|capitalize}}Id
	 * @param numeric $pContentId
	 * @access public
	 * @return void
	 */
	function {{$type.class_name}}( $p{{$type.name|capitalize}}Id=NULL, $pContentId=NULL ) {
		{{$type.base_class}}::{{$type.base_class}}();
		$this->m{{$type.name|capitalize}}Id = $p{{$type.name|capitalize}}Id;
		$this->mContentId = $pContentId;
		$this->mContentTypeGuid = BIT{{$type.name|upper}}_CONTENT_TYPE_GUID;
		$this->registerContentType( BIT{{$type.name|upper}}_CONTENT_TYPE_GUID, array(
			'content_type_guid'	  => BIT{{$type.name|upper}}_CONTENT_TYPE_GUID,
{{if $type.content_name}}
			'content_name' => '{{$type.content_name}}',
{{else}}
			'content_name' => '{{$type.name|capitalize}} data',
{{/if}}
{{if $type.content_name_plural}}
			'content_name_plural' => '{{$type.content_name_plural}}',
{{/if}}			'handler_class'		  => '{{$type.class_name}}',
			'handler_package'	  => '{{$package}}',
			'handler_file'		  => '{{$type.class_name}}.php',
{{if !empty($config.maintainer_url)}}
			'maintainer_url'	  => '{{$config.maintainer_url}}'
{{else}}
			'maintainer_url'	  => 'http://www.bitweaver.org'
{{/if}}		));
		// Permission setup
		$this->mCreateContentPerm  = 'p_{{$type.name|lower}}_create';
		$this->mViewContentPerm	   = 'p_{{$type.name|lower}}_view';
		$this->mUpdateContentPerm  = 'p_{{$type.name|lower}}_update';
		$this->mExpungeContentPerm = 'p_{{$type.name|lower}}_expunge';
		$this->mAdminContentPerm   = 'p_{{$package}}_admin';
	}

	/**
	 * load Load the data from the database
	 * 
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function load() {
		if( $this->verifyId( $this->m{{$type.name|capitalize}}Id ) || $this->verifyId( $this->mContentId ) ) {
			// LibertyContent::load()assumes you have joined already, and will not execute any sql!
			// This is a significant performance optimization
			$lookupColumn = $this->verifyId( $this->m{{$type.name|capitalize}}Id ) ? '{{$type.name|lower}}_id' : 'content_id';
			$bindVars = array();
			$selectSql = $joinSql = $whereSql = '';
			array_push( $bindVars, $lookupId = @BitBase::verifyId( $this->m{{$type.name|capitalize}}Id ) ? $this->m{{$type.name|capitalize}}Id : $this->mContentId );
			$this->getServicesSql( 'content_load_sql_function', $selectSql, $joinSql, $whereSql, $bindVars );

			$query = "
				SELECT {{$type.name|lower}}.*, lc.*,
				uue.`login` AS modifier_user, uue.`real_name` AS modifier_real_name,
				uuc.`login` AS creator_user, uuc.`real_name` AS creator_real_name,
				lch.`hits`,
				lf.`storage_path` as avatar,
				lfp.storage_path AS `primary_attachment_path`
				$selectSql
				FROM `".BIT_DB_PREFIX."{{$type.name|lower}}_data` {{$type.name|lower}}
					INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {{$type.name|lower}}.`content_id` ) $joinSql
					LEFT JOIN `".BIT_DB_PREFIX."users_users` uue ON( uue.`user_id` = lc.`modifier_user_id` )
					LEFT JOIN `".BIT_DB_PREFIX."users_users` uuc ON( uuc.`user_id` = lc.`user_id` )
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_content_hits` lch ON( lch.`content_id` = lc.`content_id` )
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_attachments` a ON (uue.`user_id` = a.`user_id` AND uue.`avatar_attachment_id`=a.`attachment_id`)
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_files` lf ON (lf.`file_id` = a.`foreign_id`)
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_attachments` la ON( la.`content_id` = lc.`content_id` AND la.`is_primary` = 'y' )
					LEFT OUTER JOIN `".BIT_DB_PREFIX."liberty_files` lfp ON( lfp.`file_id` = la.`foreign_id` )
				WHERE {{$type.name|lower}}.`$lookupColumn`=? $whereSql";
			$result = $this->mDb->query( $query, $bindVars );

			if( $result && $result->numRows() ) {
				$this->mInfo = $result->fields;
				$this->mContentId = $result->fields['content_id'];
{{if count($type.typemaps) > 0}}
				// Load any typemaps
				$this->loadTypemaps();
{{/if}}
				$this->m{{$type.name|capitalize}}Id = $result->fields['{{$type.name|lower}}_id'];

				$this->mInfo['creator'] = ( !empty( $result->fields['creator_real_name'] ) ? $result->fields['creator_real_name'] : $result->fields['creator_user'] );
				$this->mInfo['editor'] = ( !empty( $result->fields['modifier_real_name'] ) ? $result->fields['modifier_real_name'] : $result->fields['modifier_user'] );
				$this->mInfo['display_name'] = BitUser::getTitle( $this->mInfo );
				$this->mInfo['display_url'] = $this->getDisplayUrl();
				$this->mInfo['parsed_data'] = $this->parseData();

				/* =-=- CUSTOM BEGIN: load -=-= */
{{if !empty($customBlock.load)}}
{{$customBlock.load}}
{{else}}

{{/if}}
				/* =-=- CUSTOM END: load -=-= */

				{{$type.base_class}}::load();
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

{{if count($type.typemaps) > 0}}
		// Preview any typemaps
		$this->previewTypemaps($pParamHash);
{{/if}}

		// Liberty should really have a preview function that handles these
		// But it doesn't so we handle them here.
		if( isset( $pParamHash['{{$type.name}}']["title"] ) ) {
			$this->mInfo["title"] = $pParamHash['{{$type.name}}']["title"];
		}

		if( isset( $pParamHash['{{$type.name}}']["summary"] ) ) {
			$this->mInfo["summary"] = $pParamHash['{{$type.name}}']["summary"];
		}

		if( isset( $pParamHash['{{$type.name}}']["format_guid"] ) ) {
			$this->mInfo['format_guid'] = $pParamHash['{{$type.name}}']["format_guid"];
		}

		if( isset( $pParamHash['{{$type.name}}']["edit"] ) ) {
			$this->mInfo["data"] = $pParamHash['{{$type.name}}']["edit"];
			$this->mInfo['parsed_data'] = $this->parseData();
		}
	}

	/**
	 * store Any method named Store inherently implies data will be written to the database
	 * @param pParamHash be sure to pass by reference in case we need to make modifcations to the hash
	 * This is the ONLY method that should be called in order to store( create or update ) an {{$type.name|lower}}!
	 * It is very smart and will figure out what to do for you. It should be considered a black box.
	 *
	 * @param array $pParamHash hash of values that will be used to store the data
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function store( &$pParamHash ) {
		// Don't allow uses to cut off an abort in the middle.
		// This is particularly important for classes which will
		// touch the filesystem in some way.
		$abort = ignore_user_abort(FALSE);
		if( $this->verify( $pParamHash )
{{if count($type.typemaps) > 0}}
			&& $this->verifyTypemaps( $pParamHash )
{{/if}}
			&& {{$type.base_class}}::store( $pParamHash['{{$type.name}}'] ) ) {
			$this->mDb->StartTrans();
			$table = BIT_DB_PREFIX."{{$type.name|lower}}_data";
			if( $this->m{{$type.name|capitalize}}Id ) {
				if( !empty( $pParamHash['{{$type.name|lower}}_store'] ) ){
					$locId = array( "{{$type.name|lower}}_id" => $pParamHash['{{$type.name}}']['{{$type.name|lower}}_id'] );
					$result = $this->mDb->associateUpdate( $table, $pParamHash['{{$type.name|lower}}_store'], $locId );
				}
			} else {
				$pParamHash['{{$type.name|lower}}_store']['content_id'] = $pParamHash['{{$type.name}}']['content_id'];
				if( @$this->verifyId( $pParamHash['{{$type.name|lower}}_id'] ) ) {
					// if pParamHash['{{$type.name}}']['{{$type.name|lower}}_id'] is set, some is requesting a particular {{$type.name|lower}}_id. Use with caution!
					$pParamHash['{{$type.name|lower}}_store']['{{$type.name|lower}}_id'] = $pParamHash['{{$type.name}}']['{{$type.name|lower}}_id'];
				} else {
					$pParamHash['{{$type.name|lower}}_store']['{{$type.name|lower}}_id'] = $this->mDb->GenID( '{{$type.name|lower}}_data_id_seq' );
				}
				$this->m{{$type.name|capitalize}}Id = $pParamHash['{{$type.name|lower}}_store']['{{$type.name|lower}}_id'];

				$result = $this->mDb->associateInsert( $table, $pParamHash['{{$type.name|lower}}_store'] );
			}

{{if count($type.typemaps) > 0}}
			$this->storeTypemaps( $pParamHash );
{{/if}}

			/* =-=- CUSTOM BEGIN: store -=-= */
{{if !empty($customBlock.store)}}
{{$customBlock.store}}
{{else}}

{{/if}}
			/* =-=- CUSTOM END: store -=-= */


			$this->mDb->CompleteTrans();
			$this->load();
		} else {
			$this->mErrors['store'] = tra('Failed to save this').' {{$type.name|lower}}.';
		}
		// Restore previous state for user abort
		ignore_user_abort($abort);
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
		// make sure we're all loaded up of we have a m{{$type.name|capitalize}}Id
		if( $this->verifyId( $this->m{{$type.name|capitalize}}Id ) && empty( $this->mInfo ) ) {
			$this->load();
		}

		if( @$this->verifyId( $this->mInfo['content_id'] ) ) {
			$pParamHash['{{$type.name}}']['content_id'] = $this->mInfo['content_id'];
		}

		// It is possible a derived class set this to something different
		if( @$this->verifyId( $pParamHash['{{$type.name}}']['content_type_guid'] ) ) {
			$pParamHash['{{$type.name}}']['content_type_guid'] = $this->mContentTypeGuid;
		}

		if( @$this->verifyId( $pParamHash['{{$type.name}}']['content_id'] ) ) {
			$pParamHash['{{$type.name}}']['{{$type.name|lower}}_store']['content_id'] = $pParamHash['{{$type.name}}']['content_id'];
		}

		// Use $pParamHash here since it handles validation right
		$this->validateFields($pParamHash);

		if( !empty( $pParamHash['{{$type.name}}']['data'] ) ) {
			$pParamHash['{{$type.name}}']['edit'] = $pParamHash['{{$type.name}}']['data'];
		}

{{if $type.title}}
		// If title specified truncate to make sure not too long
		// TODO: This shouldn't be required. LC should validate this.
		if( !empty( $pParamHash['{{$type.name}}']['title'] ) ) {
			$pParamHash['{{$type.name}}']['content_store']['title'] = substr( $pParamHash['{{$type.name}}']['title'], 0, 160 );
		} else if( empty( $pParamHash['{{$type.name}}']['title'] ) ) { // else is error as must have title
			$this->mErrors['title'] = tra('You must enter a title for this').' $this->getContentTypeName().';
		}
{{/if}}

		// collapse the hash that is passed to parent class so that service data is passed through properly - need to do so before verify service call below
		$hashCopy = $pParamHash;
		$pParamHash['{{$type.name}}'] = array_merge( $hashCopy, $pParamHash['{{$type.name}}'] );


		/* =-=- CUSTOM BEGIN: verify -=-= */
{{if !empty($customBlock.verify)}}
{{$customBlock.verify}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: verify -=-= */


		// if we have an error we get them all by checking parent classes for additional errors and the typeMaps if there are any
		if( count( $this->mErrors ) > 0 ){
			// check errors of base class so we get them all in one go
			{{$type.base_class}}::verify( $pParamHash['{{$type.name}}'] );
{{if count($type.typemaps) > 0}}
			// And now check the typemaps
			$this->verifyTypemaps( $pParamHash );
{{/if}}
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


			/* =-=- CUSTOM BEGIN: expunge -=-= */
{{if !empty($customBlock.expunge)}}
{{$customBlock.expunge}}
{{else}}

{{/if}}
			/* =-=- CUSTOM END: expunge -=-= */

{{if count($type.typemaps) > 0}}
			// Expunge any typemaps
			$this->expungeTypemaps();
{{/if}}

			$query = "DELETE FROM `".BIT_DB_PREFIX."{{$type.name|lower}}_data` WHERE `content_id` = ?";
			$result = $this->mDb->query( $query, array( $this->mContentId ) );
			if( {{$type.base_class}}::expunge() ) {
				$ret = TRUE;
			}
			$this->mDb->CompleteTrans();
			// If deleting the default/home {{$type.name|lower}} record then unset this.
			if( $ret && $gBitSystem->getConfig( '{{$type.name|lower}}_home_id' ) == $this->m{{$type.name|capitalize}}Id ) {
				$gBitSystem->storeConfig( '{{$type.name|lower}}_home_id', 0, {{$type.name|upper}}_PKG_NAME );
			}
		}
		return $ret;
	}




	/**
	 * isValid Make sure {{$type.name|lower}} is loaded and valid
	 * 
	 * @access public
	 * @return boolean TRUE on success, FALSE on failure
	 */
	function isValid() {
		return( @BitBase::verifyId( $this->m{{$type.name|capitalize}}Id ) && @BitBase::verifyId( $this->mContentId ));
	}

	/**
	 * getList This function generates a list of records from the liberty_content database for use in a list page
	 *
	 * @param array $pParamHash
	 * @access public
	 * @return array List of {{$type.name|lower}} data
	 */
	function getList( &$pParamHash ) {
		global $gBitSystem;
		// this makes sure parameters used later on are set
		LibertyContent::prepGetList( $pParamHash );

		$selectSql = $joinSql = $whereSql = '';
		$bindVars = array();
		array_push( $bindVars, $this->mContentTypeGuid );
		$this->getServicesSql( 'content_list_sql_function', $selectSql, $joinSql, $whereSql, $bindVars, NULL, $pParamHash );


		/* =-=- CUSTOM BEGIN: getList -=-= */
{{if !empty($customBlock.getList)}}
{{$customBlock.getList}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: getList -=-= */


		// this will set $find, $sort_mode, $max_records and $offset
		extract( $pParamHash );

		if (empty($sort_mode) || ! strpos($sort_mode, '.') ) {
			$sort_mode_prefix = 'lc.';
		} else {
			$sort_mode_prefix = '';
		}

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
			SELECT {{$type.name|lower}}.*, lc.`content_id`, lc.`title`, lc.`data` $selectSql, lc.`format_guid`, lc.`user_id`, lc.`modifier_user_id`,
				uu.`email`, uu.`login`, uu.`real_name`
			FROM `".BIT_DB_PREFIX."{{$type.name|lower}}_data` {{$type.name|lower}}
				INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {{$type.name|lower}}.`content_id` ) $joinSql
				INNER JOIN `".BIT_DB_PREFIX."users_users`     uu ON uu.`user_id`     = lc.`user_id`
			WHERE lc.`content_type_guid` = ? $whereSql
			ORDER BY ".$sort_mode_prefix.$this->mDb->convertSortmode( $sort_mode );
		$query_cant = "
			SELECT COUNT(*)
			FROM `".BIT_DB_PREFIX."{{$type.name|lower}}_data` {{$type.name|lower}}
				INNER JOIN `".BIT_DB_PREFIX."liberty_content` lc ON( lc.`content_id` = {{$type.name|lower}}.`content_id` ) $joinSql
				INNER JOIN `".BIT_DB_PREFIX."users_users`     uu ON uu.`user_id`     = lc.`user_id`
			WHERE lc.`content_type_guid` = ? $whereSql";
		$result = $this->mDb->query( $query, $bindVars, $max_records, $offset );
		$ret = array();
		while( $res = $result->fetchRow() ) {
{{if $type.data}}

			if ( $gBitSystem->isFeatureActive( '{{$type.name}}_list_data' ) 
				|| !empty( $pParamHash['parse_data'] )
			){
				// parse data if to be displayed in lists 
				$parseHash['format_guid']	= $res['format_guid'];
				$parseHash['content_id']	= $res['content_id'];
				$parseHash['user_id']		= $res['user_id'];
				$parseHash['data']			= $res['data'];
				$res['parsed_data'] = $this->parseData( $parseHash ); 
			}
{{/if}}

			/* =-=- CUSTOM BEGIN: getListIter -=-= */
{{if !empty($customBlock.getListIter)}}
{{$customBlock.getListIter}}
{{else}}

{{/if}}
			/* =-=- CUSTOM END: getListIter -=-= */

			$ret[] = $res;
		}
		$pParamHash["cant"] = $this->mDb->getOne( $query_cant, $bindVars );

		// add all pagination info to pParamHash
		LibertyContent::postGetList( $pParamHash );
		return $ret;
	}

	/**
	 * getDisplayUrl Generates the URL to the {{$type.name|lower}} page
	 * 
	 * @access public
	 * @return string URL to the {{$type.name|lower}} page
	 */
	function getDisplayUrl($pSection = NULL) {
		global $gBitSystem;
		$ret = NULL;

		/* =-=- CUSTOM BEGIN: getDisplayUrl -=-= */
{{if !empty($customBlock.getDisplayUrl)}}
{{$customBlock.getDisplayUrl}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: getDisplayUrl -=-= */		

		// Did the custom code block give us a URL?
		if ($ret == NULL) {
			if( @$this->isValid() ) {
				if( $gBitSystem->isFeatureActive( 'pretty_urls' ) || $gBitSystem->isFeatureActive( 'pretty_urls_extended' )) {
					$ret = {{$PACKAGE}}_PKG_URL.'{{if empty($type.rewrite_path)}}{{$type.name}}{{else}}{{$type.rewrite_path}}{{/if}}/'.$this->m{{$type.name|capitalize}}Id;
				} else {
					$ret = {{$PACKAGE}}_PKG_URL."index.php?{{$type.name|lower}}_id=".$this->m{{$type.name|capitalize}}Id;
				}
			}
		}

		// Do we have a section request
		if (!empty($pSection)) {
			if( $gBitSystem->isFeatureActive( 'pretty_urls' ) || $gBitSystem->isFeatureActive( 'pretty_urls_extended' )) {
				if ( substr($ret, -1, 1) != "/" ) {
					$ret .= "/";
				}
				$ret .= $pSection;
			} else {
				if (preg_match('|\?|', $ret)) {
					$ret .= '&';
				} else {
					$ret .= '?';
				}
				$ret .= "section=".$pSection;
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
		$this->mVerification['{{$type.name}}_data'],
			$pParamHash['{{$type.name}}'],
			$this->mInfo);
	}

	/**
	 * validateFields validates the fields in this type
	 */
	function validateFields(&$pParamHash) {
		$this->prepVerify();
		LibertyValidator::validate(
			$this->mVerification['{{$type.name}}_data'],
			$pParamHash['{{$type.name}}'],
			$this, $pParamHash['{{$type.name}}_store']);
	}

	/**
	 * prepVerify prepares the object for input verification
	 */
	function prepVerify() {
		if (empty($this->mVerification['{{$type.name}}_data'])) {

{{foreach from=$type.fields key=fieldName item=field name=fields}}
	 		/* Validation for {{$fieldName}} */
{{if !empty($field.validator.type) && $field.validator.type != "no-input"}}
			$this->mVerification['{{$type.name}}_data']['{{$field.validator.type}}']['{{$fieldName}}'] = array(
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
	$this->mVerification['{{$type.name}}_data']['null']['{{$fieldName}}'] = TRUE;
{{/if}}
{{/foreach}}

{{foreach from=$type.typemaps key=typemapName item=typemap}}
		// prepVerify {{$typemapName}} fieldset
		$this->prep{{$typemapName|ucfirst}}Verify();
{{/foreach}}
		}
	}

	/**
	 * prepVerify prepares the object for input verification
	 */
	public function getSchema() {
		if (empty($this->mSchema['{{$type.name}}_data'])) {

{{foreach from=$type.fields key=fieldName item=field name=fields}}
	 		/* Schema for {{$fieldName}} */
			$this->mSchema['{{$type.name}}_data']['{{$fieldName}}'] = array(
				'name' => '{{$fieldName}}',
				'type' => '{{$field.validator.type|default:'null'}}',
				'label' => '{{$field.name|addslashes}}',
				'help' => '{{$field.help}}',
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
{{/foreach}}
		}

{{foreach from=$type.typemaps key=typemapName item=typemap}}
		if (empty($this->mSchema['{{$typeName}}_{{$typemapName}}'])) {
{{foreach from=$typemap.fields key=fieldName item=field name=fields}}
	 		/* Schema for {{$fieldName}} */
			$this->mSchema['{{$typeName}}_{{$typemapName}}']['{{$fieldName}}'] = array(
				'name' => '{{$fieldName}}',
				'type' => '{{$field.validator.type|default:'null'}}',
				'label' => '{{$field.name|addslashes}}',
				'help' => '{{$field.help}}',
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
{{/foreach}}
		}
{{/foreach}}

		return $this->mSchema;
	}
	
	/**
	 * getIdByField
	 * get id by type fields
	 */
	public static function getIdByField( $pKey, $pValue ) {
		global $gBitSystem;
		return $gBitSystem->mDb->getOne( "SELECT {{$type.name|lower}}_id FROM `".BIT_DB_PREFIX."{{$type.name|lower}}_data` {{$type.name|lower}} LEFT JOIN `".BIT_DB_PREFIX."liberty_content` lc ON ({{$type.name|lower}}.`content_id` = lc.`content_id`) WHERE {{$type.name|lower}}.`".$pKey."` = ?", $pValue );
	}
	
	// Getters for reference column options - return associative arrays formatted for generating html select inputs
{{foreach from=$type.fields key=fieldName item=field}}
{{if $field.validator.type == 'reference' && $field.input.type == 'select'}}
	function get{{$field.name|replace:" ":""}}Options( &$pParamHash=array() ){
		$bindVars = array();
		$joinSql = $whereSql = "";
{{assign var=customlabel value="`$fieldName`_options"}}
		/* =-=- CUSTOM BEGIN: {{$customlabel}} -=-= */
{{if !empty($customBlock.$customlabel)}}
{{$customBlock.$customlabel}}
{{else}}

{{/if}}
		/* =-=- CUSTOM END: {{$customlabel}} -=-= */
		$query = "{{$field.input.optionsHashQuery}} $joinSql $whereSql";
		return $this->mDb->getAssoc( $query, $bindVars );
	}

{{/if}}{{/foreach}}



{{if count($type.typemaps) > 0}}
{{literal}}
	// {{{ =================== TypeMap Functions for FieldSets ====================
{{/literal}}

	function verifyTypemaps( &$pParamHash ) {
{{foreach from=$type.typemaps key=typemapName item=typemap}}
			// verify {{$typemapName}} fieldset
			$this->verify{{$typemapName|ucfirst}}($pParamHash);
{{/foreach}}
			return ( count($this->mErrors) == 0);
	}

	function previewTypemaps( &$pParamHash ) {
{{foreach from=$type.typemaps key=typemapName item=typemap}}
			// verify {{$typemapName}} fieldset
			$this->preview{{$typemapName|ucfirst}}Fields($pParamHash);
{{/foreach}}
	}

	function storeTypemaps( &$pParamHash ) {
{{foreach from=$type.typemaps key=typemapName item=typemap}}
			// store {{$typemapName}} fieldset
			$this->store{{$typemapName|ucfirst}}Mixed($pParamHash, TRUE);
{{/foreach}}
			return ( count($this->mErrors) == 0);
	}

	function expungeTypemaps() {
		if ($this->isValid() ) {
			$paramHash = array('content_id' => $this->mContentId);
{{foreach from=$type.typemaps key=typemapName item=typemap}}
			// expunge {{$typemapName}} fieldset
			$this->expunge{{$typemapName|ucfirst}}($paramHash);
{{/foreach}}
		}
	}

	function loadTypemaps() {
{{foreach from=$type.typemaps key=typemapName item=typemap}}
			// load {{$typemapName}} list from sub map
			$this->mInfo['{{$typemapName}}'] = $this->list{{$typemapName|ucfirst}}();
{{/foreach}}
	}

{{literal}}
	// }}} -- end of TypeMap function for fieldsets
{{/literal}}

{{foreach from=$type.typemaps key=typemapName item=typemap}}
{{include file="typemap_methods_inc.php.tpl"}}
{{/foreach}}
{{/if}}
{{literal}}
	// {{{ =================== Custom Helper Mthods  ====================
{{/literal}}

	/* This section is for any helper methods you wish to create */
	/* =-=- CUSTOM BEGIN: methods -=-= */
{{if !empty($customBlock.methods)}}
{{$customBlock.methods}}
{{else}}

{{/if}}
	/* =-=- CUSTOM END: methods -=-= */

{{literal}}
	// }}} -- end of Custom Helper Methods
{{/literal}}
}

