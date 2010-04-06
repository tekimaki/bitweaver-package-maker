<?php
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
 * @package pkgmkr
 * @subpackage functions
 */


function usage($argv) {
  echo "Usage: ".$argv[0]." <package>\n\n";
  die;
}

function convert_typename($file, $type) {
  $tmp_file = preg_replace("/type/", strtolower($type), $file);
  return preg_replace("/Type/", ucfirst(strtolower($type)), $tmp_file);
}

function convert_packagename($file, $config) {
  $pkg_file = preg_replace("/package/", $config['package'], $file);
  return preg_replace("/Package/", $config['Package'], $pkg_file);
}  

function copy_files($config, $dir, $files) {
  global $gVerbose;

  foreach ($files as $file) {
    $pkg_file = convert_packagename($file, $config);
    $filename = $dir."/".$pkg_file;

    if ($gVerbose) echo " ".$filename."\n";

    if (!copy(RESOURCE_DIR.$file, $filename)) {
      echo "Error copying file: $file";
      exit;
    }
  }
}

function render_files($config, $dir, $files) {
  foreach($config['types'] as $type => $params) {    
    global $gBitSmarty;
    $params['class'] = $type;
    $gBitSmarty->assign('render', $params);
    foreach ($files as $file) {
      $pkg_file = convert_packagename(convert_typename($file, $type), $config);
      $template = $file.".tpl";
      // Render the file
      render_file($dir, $pkg_file, $template, $config);
    }
  }
}

function generate_files($config, $dir, $files) {
  foreach ($files as $file) {
    $pkg_file = convert_packagename($file, $config);
    $template = $file.".tpl";
    // Render the file
    render_file($dir, $pkg_file, $template, $config);
  }
}

function render_file($dir, $file, $template, $config) {
  global $gBitSmarty, $gVerbose;
  
  $filename = $dir."/".$file;
  if ($gVerbose) echo " ".$filename."\n";

  if (file_exists($filename)) {
     if (is_file($filename)) {
     	if (is_readable($filename)) {
	   if ($contents = file_get_contents($filename)) {
	      $count = preg_match_all(
	      	      '@\s*'
		      .'(?:/\*|#|\{\*) =-=- CUSTOM BEGIN: ([^\s]*) -=-= (?:\*/|#|\{\*)'
		      .'(.*)'
		      .'(?:/\*|#|\{\*) =-=- CUSTOM END: \1 -=-= (?:\*/|#|\*\})'
		      .'@ms'
		      ,
		      $contents,
		      $matches);
              // print_r($matches);
	      if ($count > 0) {
		  $customBlock = array();
		  foreach($matches[1] as $id => $field) {
		      $customBlock[$field] = substr($matches[2][$id], 1, -3);
		  }
		  $gBitSmarty->assign('customBlock', $customBlock);
	      }
	   } else {
	     echo "Unable to read old file: $filename";
	     exit;
	   }
	}
     } else {
       echo "$filename exists but is not a file!";
       exit;
     }
  }

  // Get the contents of the file from smarty
  $content = $gBitSmarty->fetch('bitpackage:pkgmkr/'.$template);
  if (!empty($content)) {
    if (!$handle = fopen($filename, 'w+')) {
      echo "Cannot open file ($filename)";
      exit;
    }

    // Write $content to our opened file.
    if (fwrite($handle, $content) === FALSE) {
      echo "Cannot write to file ($filename)";
      exit;
    }
  
    fclose($handle);

    if (preg_match("/.php$/", $filename)) {
      lint_file($filename);
    }
  } else {
    echo "Error generating file: $filename\n";
    exit;
  }
}

function validate_config($config) {
  // TODO: Would be nice to genericize these checks
  // so that you would just modify a file in resources
  // to modify what is validated instead of writing code
  // here. Would make the generator a more flexible code
  // generator.
  if (empty($config['package'])) {
    echo "A package is required.\n";
    exit;
  }

  if (empty($config['description'])) {
    echo "A description is required.\n";
    exit;
  }

  if (empty($config['version'])) {
    echo "A version number is required.\n";
    exit;
  }
  
  foreach ($config['types'] as $typeName => $type) {
    if (empty($type['description'])) {
      echo "A description is required for $typeName\n";
      exit;
    }
    if (empty($type['class_name'])) {
      echo "A class name is required for $typeName\n";
      exit;
    }
    if (empty($type['base_class'])) {
      echo "A base class is required for $typeName\n";
      exit;
    }
    if (empty($type['base_package'])) {
      echo "A base package is required for $typeName\n";
      exit;
    }
    if (empty($type['content_description'])) {
      echo "A content description is required for $typeName\n";
      exit;
    }
    foreach ($type['fields'] as $fieldName => $field) {
      if (empty($field['schema'])) {
        echo "A schema is required for field $fieldName in type $typeName\n";
	exit;
      }
      if (empty($field['schema']['type'])) {
        echo "A type is required in the schema for field $fieldName in type $typeName\n";
	exit;
      }
    }
  }

  // TODO: LOTS MORE VALIDATION HERE!!!!

  //  print_r($config);

  // Generate a few capitalization variations
  $config['package'] = strtolower($config['package']);
  $config['PACKAGE'] = strtoupper($config['package']);
  $config['Package'] = ucfirst(strtolower($config['package']));

  return $config;
}

function check_args($argv) {
  if (count($argv) != 2) {
    usage($argv);
  }
  if (is_file($argv[1])) {
    return validate_config(Spyc::YAMLLoad($argv[1]));
  }
  echo "Not a readable file: " .$argv[1];
  exit;
}

function init_smarty($config) {
  global $gBitSmarty;

  // Assign package in various cases to the context for
  // easier to read templates.
  $gBitSmarty->assign('package', $config['package']);
  $gBitSmarty->assign('PACKAGE', $config['PACKAGE']);
  $gBitSmarty->assign('Package', $config['Package']);

  // Assign the configuration to context
  $gBitSmarty->assign('config', $config);

  // Turn off tr prefilter so those tags come out right
  $gBitSmarty->unregister_prefilter('tr');
}

function activate_pkgmkr() {
  global $gBitSystem;
  if (!$gBitSystem->isPackageActive('pkgmkr')) {
    $gBitSystem->setConfig('package_pkgmkr', 'y');
    return true;
  }
  return false;
}

function inactivate_pkgmkr($off) {
  global $gBitSystem;
  if ($off) {
    $gBitSystem->setConfig('package_pkgmkr', 'n');
  }
}

function generate_package($config) {
  global $gVerbose;

  if ($gVerbose) echo "Generating package: ".$config['package']."\n";

  // Load the files we are to generate
  $gFiles = Spyc::YAMLLoad(RESOURCE_DIR.'files.yaml');

  // Now figure out the real directory and file names
  foreach ($gFiles as $file_dir => $actions) {
    $dir = convert_packagename($file_dir, $config);
    
    // Does the directory exist
    if (!is_dir($dir)) {
      echo " ".$dir."\n";
      if (!mkdir($dir)) {
	echo "Could not create directory!";
	exit;
      }
    }
    
    foreach ($actions as $action => $files) {
      if ($action == "generate") {
	generate_files($config, $dir, $files);	
      } elseif ($action == "render") {
	render_files($config, $dir, $files);
      } elseif ($action == "copy") {
	copy_files($config, $dir, $files);
      } else {
	echo "Unknown action: " . $action;
	exit;
      }
    }
  }
}

function lint_file($filename) {
  global $gVerbose;
  if ($gVerbose) echo " ... verifying ...\n";

  exec("php -l $filename", $output, $ret);
  if ($ret != 0) {
    echo "ERROR: The generated file: $filename is invalid.";
    echo $output;
    exit;
  }
}