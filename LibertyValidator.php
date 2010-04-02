<?php
/**
 * Utility class for validating various kinds of input.
 *
 */

class LibertyValidator {	

	function preview(&$pVars, &$pParamHash, &$store) {
		foreach($pVars as $type => $vars) {
			switch($type) {
			case 'string':
				preview_strings($vars, $pParamHash, $store);
				break;
			case 'int':
			case 'long':
				preview_integers($vars, $pParamHash, $store);
				break;
			case 'real':
			case 'float':
			case 'double':
				preview_reals($vars, $pParamHash, $store);
				break;
			case 'boolean':
				preview_booleans($vars, $pParamHash, $store);
				break;
			case 'phone':
				preview_phones($vars, $pParamHash, $store);
				break;
			case 'date':
				preview_dates($vars, $pParamHash, $store);
				break;
			case 'time':
				preview_times($vars, $pParamHash, $store);
				break;
			case 'null':
				preview_null($vars, $pParamHash, $store);
			default:
				global $gBitSystem;
				$gBitSystem->fatalError("Unsupported validation type: ".$type);
				break;
			}
		}
	}

	function validate(&$pVars, &$pParamHash, &$pObject, &$store) {
		foreach($pVars as $type => $vars) {
			switch($type) {
			case 'string':
				LibertyValidator::validate_strings($vars, $pParamHash, $pObject, $store);
				break;
			case 'int':
			case 'long':
				LibertyValidator::validate_integers($vars, $pParamHash, $pObject, $store);
				break;
			case 'real':
			case 'float':
			case 'double':
				LibertyValidator::validate_reals($vars, $pParamHash, $pObject, $store);
				break;
			case 'boolean':
				LibertyValidator::validate_booleans($vars, $pParamHash, $pObject, $store);
				break;
			case 'phone':
				LibertyValidator::validate_phones($vars, $pParamHash, $pObject, $store);
				break;
			case 'date':
				LibertyValidator::validate_dates($vars, $pParamHash, $pObject, $store);
				break;
			case 'time':
				LibertyValidator::validate_times($vars, $pParamHash, $pObject, $store);
				break;
			case 'null':
				LibertyValidator::validate_null($vars, $pParamHash, $pObject, $store);
				break;
			default:
				global $gBitSystem;
				$gBitSystem->fatalError("Unsupported validation type: ".$type);
				break;
			}
		}
	}

	function preview_null(&$pVars, &$pParamHash, &$pStore) {
		 foreach( $pVars as $var ) {
		 	  $pStore[$var] = isset($pParamHash[$var]) ? 
				$pParamHash[$var] : NULL;
		}
	}

	function validate_null($pVars, &$pParamHash, &$pObject, &$store) {
		 foreach( $pVars as $var ) {
		 	  $pStore[$var] = isset($pParamHash[$var]) ? 
				$pParamHash[$var] : NULL;
		}
	}

	function preview_strings(&$pVars, &$pParamHash, &$pStore) {
		foreach( $pVars as $var => $constraints) {
			$pStore[$var] = isset($pParamHash[$var]) ? 
				$pParamHash[$var] : NULL;
		}
	}

	function validate_strings($pVars, &$pParamHash, &$pObject, &$store) {
		foreach( $pVars as $var => $constraints) {
			if( !empty( $pStore[$var] ) &&
				empty ( $pParamHash[$var] ) ) {
				
				if (isset($constraints['required']) && $constraints['required']) {
					$pObject->mErrors[$var] = 'A value for ' . $constraints['name']
						. ' is required.';
				}
				else {				
					// Somebody deleted the value, we need to null it out
					$store[$var] = NULL;
				}
			}
			else if( empty( $pParamHash[$var] ) ) {
				if (isset($constraints['required']) && $constraints['required']) {
					$pObject->mErrors[$var] = 'A value for ' . $constraints['name']
						. ' is required.';
				}
				else {
					// Somebody deleted the value, we need to null it out
					$store[$var] = NULL;
				}
			}
			else {
				if (isset($constraints['length']) &&
					strlen($pParamHash[$var]) > $constraints['length']) {
					$pObject->mErrors[$var] =
						'The length of the '.$constraints['name'].' is too long.';
				}
				else {
					$store[$var] = $pParamHash[$var];
				}
			}
		}		

		return (count($pObject->mErrors) == 0);
	}

	function preview_integers(&$pVars, &$pParamHash, &$pStore) {
		foreach( $pVars as $var => $constraints) {
			$pStore[$var] = isset($pParamHash[$var]) ? $pParamHash[$var] : NULL;
		}
	}

	function validate_integers(&$pVars, &$pParamHash, &$pObject, &$store) {
		foreach( $pVars as $var => $constraints) {
			if (!empty( $pParamHash[$var] ) ) {
				if (is_numeric($pParamHash[$var])) {
					if (preg_match('/^([0-9]+)\.?0*$/', 
							$pParamHash[$var], $match)) {
						if (empty($constraints['min']) ||
							$pParamHash[$var] < $constraints['min']) {
							if (empty($constraints['max']) ||
								$pParamHash[$var] > $constraints['max']) {
								$store[$var] = $match[1];
							}
							else {
								$pObject->mErrors[$var] = 'The value of '
									. $contraints['name']
									. 'is larger than the maximum of '
									. $constraints['min'];
							}
						}
						else {
							$pObject->mErrors[$var] = 'The value of '
								. $contraints['name']
								. 'is less than the minimum of '
								. $constraints['min'];
						}
					}
					else {
						$pObject->mErrors[$var] = 'The value of '
							. $constraints['name'] 
								. ' is not an integer.';
					}
				}
				else {
					$pObject->mErrors[$var] = 'The value of ' . 
						$constraints['name'] 
						. ' is not an integer.';
				}
			}
			else {
				if (isset($constraints['required']) && $constraints['required']) {
					$pObject->mErrors[$var] = 'A value for ' .$constraints['name']
						. ' is required.';
				}
				else {
					$store[$var] = '0';
				}
			}
		}

		return (count($pObject->mErrors) == 0);
	}

	function preview_dates(&$pVars, &$pParamHash, &$pStore) {
		foreach( $pVars as $var => $constraints) {
			if( isset( $pParamHash[$var]['Month'] ) &&
				isset( $pParamHash[$var]['Day'] ) &&
				isset( $pParamHash[$var]['Year'] ) )
			{
				$pStore[$var] = $pParamHash[$var]['Year'].'-'.
					$pParamHash[$var]['Month'].'-'.$pParamHash[$var]['Day'];
			}
		}
	}

	function validate_dates($pVars, &$pParamHash, &$pObject, &$store) {
		foreach( $pVars as $var => $constraints) {
			if( isset( $pParamHash[$var]['Month'] ) &&
				isset( $pParamHash[$var]['Day'] ) &&
				isset( $pParamHash[$var]['Year'] ) )
				{
					if (! ( is_numeric($pParamHash[$var]['Month']) &&
							is_numeric($pParamHash[$var]['Day']) &&
							is_numeric($pParamHash[$var]['Year']) ) ) {
						$pObject->mErrors[$var] = 'The value of the ' . 
							$constraints['name'] . ' is invalid.';
					}
					else {
						if( strlen( $pParamHash[$var]['Month'] ) == 1 ) {
							$pParamHash[$var]['Month'] = 
								'0'.$pParamHash[$var]['Month'];
						}
						if( strlen( $pParamHash[$var]['Day'] ) == 1 ) {
							$pParamHash[$var]['Day'] = '0'.$pParamHash[$var]['Day'];
						}
						$store[$var] =
							$pParamHash[$var]['Year'].
							$pParamHash[$var]['Month'].
							$pParamHash[$var]['Day'];
						if (strlen($store[$var]) != 8) {
							$pObject->mErrors[$var] = 'The value of ' . 
								$constraint['name'] . ' is invalid.';
						}
					}
				}
			else if (isset($contraints['required']) && $constraints['required']) {
				$pObject->mErrors[$var] = 'A value for ' .
					$constraint['name'] . ' is required.';
			}
		}

		return (count($pObject->mErrors) == 0);
	}
	
	function preview_times(&$pVars, &$pParamHash, &$pStore) {
		global $gBitSystem;
		$offset = $gBitSystem->get_display_offset();
		$bd = new BitDate($offset);
		foreach( $pVars as $var => $constraints) {
			if (isset( $pParamHash[$var] ) ) {
				//				$tz = date_default_timezone_get();
				//				date_default_timezone_set('PST');
				$pStore[$var] =
					$bd->gmmktime(($pParamHash[$var]['Meridian'] == 'pm' ?
							$pParamHash[$var]['Hour'] + 12 : 
							$pParamHash[$var]['Hour']),
								  $pParamHash[$var]['Minute'], 0,
								  1, 2, 1970) - $offset;
				//				date_default_timezone_set($tz);
			}
		}
	}

	function validate_times($pVars, &$pParamHash, &$pObject, &$store) {
		global $gBitSystem;
		$offset = $gBitSystem->get_display_offset();
		$bd = new BitDate($offset);

		foreach ($pVars as $var => $constraints) {
			if (isset( $pParamHash[$var] ) ) {
				if ((!isset($pParamHash[$var]['Meridian']) || 
						($pParamHash[$var]['Meridian'] == 'am' ||
							$pParamHash[$var]['Meridian'] == 'pm')) &&
					(isset($pParamHash[$var]['Hour']) &&
						is_numeric($pParamHash[$var]['Hour'])) && 				   
					(!isset($pParamHash[$var]['Minute']) || 
						is_numeric($pParamHash[$var]['Minute']) && 
						(!isset($pParamHash[$var]['Second']) || 
							is_numeric($pParamHash[$var]['Second'])))) {
					
					// We work from January 2nd to leave space for negative
					// timezone offsets.
					if (isset($pParamHash[$var]['Meridian'])) {
						$store[$var] = 
							$bd->gmmktime(($pParamHash[$var]['Meridian'] == 'pm' && $pParamHash[$var]['Hour'] < 12 ?
									$pParamHash[$var]['Hour'] + 12 :
									$pParamHash[$var]['Hour']),
								$pParamHash[$var]['Minute'],
								isset($pParamHash[$var]['Second']) ?
								$pParamHash[$var]['Second'] : 0,
								1, 2, 1970);
					}
					else {
						$store[$var] = $bd->gmmktime($pParamHash[$var]['Hour'],
							$pParamHash[$var]['Minute'],
							isset($pParamHash[$var]['Second']) ?
							$pParamHash[$var]['Second'] : 0,
							1, 2, 1970);
					}										
					//				date_default_timezone_set($tz);
					$store[$var] = $bd->getUTCFromDisplayDate($store[$var]);
				}
				else {
					$pObject->mErrors[$var] = 'The value for '. 
						$constraints['name']
						. ' is invalid.';
				}
			}
			else if (isset($constraints['required']) && $constraints['required']) {
				$pObject->mErrors[$var] = 'A value for '. $constraints['name']
					. ' is required.';
			}
		}

		return (count($pObject->mErrors) == 0);
	}

	function preview_booleans($pVars, &$pParamHash, &$pStore){
		foreach ($pVars as $var => $constrants) {
			if (isset($pParamHash[$var])) {
				$pStore[$var] =
					($pParamHash[$var] == 'on' ||
						$pParamHash[$var] == 1 ||
						$pParamHash[$var] == 'yes' )
					? 1 : 0;
			}
			else {
				$pStore[$var] = 0;
			}
		}
	}

	function validate_booleans($pVars, &$pParamHash, &$pObject, &$store) {
		foreach ($pVars as $var => $constraints) {
			if (isset($pParamHash[$var])) {
				$store[$var] =
					($pParamHash[$var] == 'on' ||
						$pParamHash[$var] == 1 ||
						$pParamHash[$var] == 'yes') 
					? 1 : 0;
			}
			else {
				$store[$var] = 0;
			}
		}
		
		return (count($pObject->mErrors) == 0);
	}

	function preview_reals(&$pVars, &$pParamHash, &$pStore) {
		foreach( $pVars as $var => $constraints) {
			$pStore[$var] = isset($pParamHash[$var]) ? $pParamHash[$var] : NULL;
		}
	}

	function validate_reals($pVars, &$pParamHash, &$pObject, &$store) {
		foreach( $pVars as $var => $constraints) {
			if (!empty( $pParamHash[$var] ) ) {
				if (is_numeric($pParamHash[$var])) {
					if (preg_match('/^([0-9]+\.?[0-9]*)$/', 
							$pParamHash[$var], $match)) {
						if (empty($constraints['min']) ||
							$pParamHash[$var] < $constraints['min']) {
							if (empty($constraints['max']) ||
								$pParamHash[$var] > $constraints['max']) {
								$store[$var] = $match[1];
							}
							else {
								$pObject->mErrors[$var] = 'The value of '
									. $contraints['name']
									. 'is larger than the maximum of '
									. $constraints['min'];
							}
						}
						else {
							$pObject->mErrors[$var] = 'The value of '
								. $contraints['name']
								. 'is less than the minimum of '
								. $constraints['min'];
						}
					}
					else {
						$pObject->mErrors[$var] = 'The value of '
							. $constraints['name'] 
							. ' is not an integer.';
					}
				}
				else {
					$pObject->mErrors[$var] = 'The value of ' . 
						$constraints['name'] 
						. ' is not an integer.';
				}
			}
			else {
				if (isset($constraints['required']) && $constraints['required']) {
					$pObject->mErrors[$var] = 'A value for ' .$constraints['name']
						. ' is required.';
				}
				else {
					$store[$var] = '0';
				}
			}
		}

		return (count($pObject->mErrors) == 0);
	}

	function preview_phone($pVars, &$pParamHash, &$pStore){
		foreach ($pVars as $var => $constrants) {
			$pStore[$var] = isset($pParamHash[$var]) ? $pParamHash[$var] : NULL;
		}
	}	

	function validate_phone($pVars, &$pParamHash, &$pObject, &$store) {
		foreach( $pVars as $var => $constraints ) {
			if( isset( $pParamHash[$var] ) ) {
				// We just strip down to what we seek.
				// TODO: Verify valid characters first
				$phone = preg_replace('/[^0-9a-zA-Z]/', '',$pParamHash[$var]);
				if( strlen( $phone ) != 0 && strlen( $phone ) != 10 && strlen( $phone ) != 12 ) {
					$pObject->mErrors[$var] = 'You must enter a 10 or 12 character value for ' . $constraints['name'];
				}
				else {
					$store[$var] = $phone;
				}
			}
			else if (isset($constraints['required']) && $constraints['required']) {
				$pObject->mErrors[$var] = 'A value for ' . $constraints['name']
					. ' is required.';
			}
			else {
				$store[$var] = NULL;
			}
		}
	}
}