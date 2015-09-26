#!/usr/bin/env node

/**
 * System
 */
var path = require('path'),
	fs = require('fs');

/**
 * Framework
 */
require('coffee-script/register');
var _ = require('lodash'),
	Gastropod = require('../src'),
	Program = require('commander'),
	nconf = require('nconf'),
	debug = require('debug')('gastropod/bin');

/**
 * Project
 */
var pkg = require('../package.json');


/**
 * Gastropod Command Line Tool
 */
Program
	.version(pkg.version)

	/**
	 * Setup options
	 */
	.option('-c --config <path>', 'Use config file')
	.option('-v --verbose', 'More logging');

/**
 * The guts
 */
Program
	.command('run <tasks> [otherTasks...]')
	.action(function(task, otherTasks, options){
		// join tasks names
		var tasks = [task];
		if (otherTasks && otherTasks.length){
			debug('adding tasks', otherTasks);
			tasks = tasks.concat(otherTasks);
		}

		// load user supplied config
		var config = {};
		if (options.parent.config){
			debug('attempting to load user config', options.parent.config);
			try {
				config = require(options.parent.config);
			}catch(err){
				debug('error loading userconfig', err);
				config = {}
			}
		}

		// initialise
		debug('spawning a gastropod')
		runner = new Gastropod()

		// start
		debug('starting the gastropod')
		runner.run(tasks)
	});


Program
	.parse(process.argv)
