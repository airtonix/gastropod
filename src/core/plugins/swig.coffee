#
# System
#
fs = require('fs')
path = require('path')

#
# Framework
#
_ = require 'lodash'
through = require('through2')
swig = require('swig')
clone = require('clone')
gutil = require('gulp-util')
postmortem = require 'postmortem'
deepmerge = require 'deepmerge'
debug = require('debug')('gastropod/core/plugins/swig')

#
# Project
#
PluginError = gutil.PluginError

#
# Exports
#



module.exports = ($)->

	debug 'exporting new '

	(options={}) ->

		debug 'setting up swig instance'
		if options.defaults
			swig.setDefaults options.defaults

		debug 'setting up swig instance'
		try
			options.setup?(swig)
		catch err
			postmortem.prettyPrint err

		streamFinish = (done)->
			done()

		streamStart = (file, ext, done)->

			debug 'processing file', file.relative

			data = options.data or {}

			if _.isFunction data
				debug 'global data is a function'
				data = data file

			if file.data
				debug 'merging data from previous stream'
				data = deepmerge {}, file.data, data

			try
				debug 'parsing', file.path
				template = swig.compile(String(file.contents), filename: file.path)
				debug 'compiling', file.path
				compiled = template(data)
				debug 'done'
				file.contents = new Buffer compiled
				done null, file

			catch err
				postmortem.prettyPrint err
				done()

			return

		debug 'exporting through stream'
		return through.obj streamStart, streamFinish