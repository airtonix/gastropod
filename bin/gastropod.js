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

		// initialise
		debug('spawning a gastropod')
		runner = new Gastropod(options.parent)

		// start
		debug('starting the gastropod')
		runner.run(tasks)
	});

Program
	.command('list <what>')
	.action(function(what, options){
		runner = new Gastropod(options.parent)
		runner.list(what)
	});

Program
	.command('serve')
	.action(function(options){
		runner = new Gastropod(options.parent)
		runner.serve()
	});

Program
	.parse(process.argv)
