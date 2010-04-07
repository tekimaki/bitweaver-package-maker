#!/usr/bin/php
<?php /* -*- Mode: php; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4; -*- */
/* vim:set ft=php ts=4 sw=4 sts=4 */
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

// Generate the package
generate_package($config);

// Inactivate if we need to
inactivate_pkgmkr($active);
