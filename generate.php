#!/usr/bin/php
<?php /* -*- Mode: php; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ft=php ts=2 sw=2 sts=2 cindent: */
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

global $gShellScript, $gVerbose;
$gShellScript = TRUE;
$gVerbose = TRUE;

// Define where we get some resources from.
// Files to be copied will come from here.
define("RESOURCE_DIR", "resources/");

// Load our libraries
require_once("../kernel/setup_inc.php");
require_once("spyc-0.4.5/spyc.php");
require_once("functions_inc.php");

// Activate this package so we get template rendering
$active = activate_pkgmkr();

// What package are we building today boys and girls?
$config = check_args($argv);

// Initialize smarty
init_smarty($config);

// Generate the package
generate_package($config);

// Inactivate if we need to
inactivate_pkgmkr($active);
