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

// Load our libraries
require_once("spyc-0.4.5/spyc.php");
require_once("functions_inc.php");

pkgmkr_setup();

// What package are we building today boys and girls?
$config = check_args($argv);

// Generate the package
generate_package($config);


