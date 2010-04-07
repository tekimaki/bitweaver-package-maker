<?php /* -*- mode: foobar; nick: t; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2; -*- */
/* vim:set ft=php ts=8 sw=4 sts=4 cindent: */
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

function error($message, $fatal=TRUE) {
  echo $message;
  echo "\n";
  if ($fatal)
    die;
}

function message($message) {
  global $gVerbose;
  if ($gVerbose) {
    echo $message;
    echo "\n";
  }
}

function convert_typename($file, $type, $className) {
  $tmp_file = preg_replace("/type/", strtolower($type), $file);
  return preg_replace("/TypeClass/", $className, $tmp_file);
}

function convert_packagename($file, $config) {
  $pkg_file = preg_replace("/package/", $config['package'], $file);
  return preg_replace("/Package/", $config['Package'], $pkg_file);
}  

function copy_files($config, $dir, $files) {
  foreach ($files as $file) {
    $pkg_file = convert_packagename($file, $config);
    $filename = $dir."/".$pkg_file;

    message(" ".$filename);

    if (!copy(PKGMKR_PKG_DIR.'/'.RESOURCE_DIR.$file, $filename)) {
      error("Error copying file: $file");
    }
  }
}

function render_type_files($config, $dir, $files) {
  foreach($config['types'] as $type => $params) {    
    global $gBitSmarty;
    $params['name'] = $type;
    $gBitSmarty->assign('type', $params);
    foreach ($files as $file) {
      $pkg_file = convert_packagename(convert_typename($file, $type, $params['class_name']), $config);
      $template = $file.".tpl";
      // Render the file
      render_type_file($dir, $pkg_file, $template, $config);
    }
  }
}

function generate_package_files($config, $dir, $files) {
  foreach ($files as $file) {
    $pkg_file = convert_packagename($file, $config);
    $template = $file.".tpl";
    // Render the file
    render_type_file($dir, $pkg_file, $template, $config);
  }
}

function render_type_file($dir, $file, $template, $config) {
  global $gBitSmarty;
  
  $filename = $dir."/".$file;
  message(" ".$filename);

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
	     error("Unable to read old file: $filename");
	   }
	}
     } else {
       error("$filename exists but is not a file!");
     }
  }

  // Get the contents of the file from smarty
  $content = $gBitSmarty->fetch('bitpackage:pkgmkr/'.$template);
  if (!empty($content)) {
    if (!$handle = fopen($filename, 'w+')) {
      error("Cannot open file ($filename)");
    }

    // Write $content to our opened file.
    if (fwrite($handle, $content) === FALSE) {
      error("Cannot write to file ($filename)");
    }
  
    fclose($handle);

    if (preg_match("/.php$/", $filename)) {
      lint_file($filename);
    }
  } else {
    error("Error generating file: $filename");
  }
}

function validate_config(&$config) {
  // TODO: Would be nice to genericize these checks
  // so that you would just modify a file in resources
  // to modify what is validated instead of writing code
  // here. Would make the generator a more flexible code
  // generator.
  if (empty($config['package'])) {
    error("A package is required.");
  }

  if (empty($config['description'])) {
    error("A description is required.");
  }

  if (empty($config['version'])) {
    error("A version number is required.");
  }
  
  foreach ($config['types'] as $typeName => $type) {
    if (empty($type['class_name'])) {
       $config['types'][$typeName]['class_name'] = 'Bit'.ucfirst($typeName);
    }
    if (empty($type['description'])) {
      error("A description is required for $typeName");
    }
    if (empty($type['base_class'])) {
      error("A base class is required for $typeName");
    }
    if (empty($type['base_package'])) {
      error("A base package is required for $typeName");
    }
    if (empty($type['content_description'])) {
      error("A content description is required for $typeName");
    }
    foreach ($type['fields'] as $fieldName => $field) {
      if (empty($field['schema'])) {
        error("A schema is required for field $fieldName in type $typeName");
      }
      if (empty($field['schema']['type'])) {
        error("A type is required in the schema for field $fieldName in type $typeName");
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
  error("Not a readable file: " .$argv[1]);
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

  message("Generating package: ".$config['package']);

  // Load the files we are to generate
  $gFiles = Spyc::YAMLLoad(RESOURCE_DIR.'files.yaml');

  // Now change directory to BIT_ROOT_PATH to generate the package in
  // the root of this install.
  chdir(BIT_ROOT_PATH);

  // Now figure out the real directory and file names
  foreach ($gFiles as $file_dir => $actions) {
    $dir = convert_packagename($file_dir, $config);
    
    // Does the directory exist
    if (!is_dir($dir)) {
      echo " ".$dir."\n";
      if (!mkdir($dir)) {
	error("Could not create directory!");
      }
    }
    
    foreach ($actions as $action => $files) {
      if ($action == "package") {
	generate_package_files($config, $dir, $files);	
      } elseif ($action == "type") {
	render_type_files($config, $dir, $files);
      } elseif ($action == "copy") {
	copy_files($config, $dir, $files);
      } else {
	error("Unknown action: " . $action);
      }
    }
  }
}

function lint_file($filename) {
  message(" ... verifying ...");

  exec("php -l $filename", $output, $ret);
  if ($ret != 0) {
    error("ERROR: The generated file: $filename is invalid.", FALSE);
    error($output);
  }
}

/* Local Variables: mode: foobar; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */