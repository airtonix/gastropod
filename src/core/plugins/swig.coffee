#
# System
#
fs = require('fs')
path = require('path')

#
# Framework
#
es = require('event-stream')
swig = require('swig')
clone = require('clone')
gutil = require('gulp-util')
debug = require('debug')('gastropod/core/plugins/swig')

#
# Project
#
PluginError = gutil.PluginError

#
# Exports
#
extend = (target) ->
	sources = [].slice.call(arguments, 1)
	sources.forEach (source) ->
		for prop of source
			if source.hasOwnProperty(prop)
				target[prop] = source[prop]
		return
	target


module.exports = (options) ->

	gulpswig = (file, callback) ->
		data = opts.data or {}

		if typeof data == 'function'
			data = data(file)

		if file.data
			data = extend(file.data, data)

		try
			tpl = swig.compile(String(file.contents), filename: file.path)
			compiled = tpl(data)
			file.contents = new Buffer(compiled)
			callback null, file

		catch err
			debug "PluginError", err
			callback new PluginError('gulp-swig', err)
			# callback()

		return

	'use strict'
	opts = if options then clone(options) else {}

	if opts.defaults
		swig.setDefaults opts.defaults

	if opts.setup and typeof opts.setup == 'function'
		opts.setup swig

	es.map gulpswig
