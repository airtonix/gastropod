###*
 * Allow loading templates from multiple silos of templates
 * 	- use case is to use NPM packages to store patternalbs of templates for specific
 * 	ui components:
 * 		- node_modules/fe-patternlab-stickyheader
 * 		- node_modules/fe-patternlab-forms
 * 		- node_modules/fe-patternlab-offcanvas-menu
 *
 *
 * Where each modules package.json contains something like:
 *  ```
 * 	"patternlab": "./src/patterns"
 * 	```
 *
 *
###

#
# Third Party
async = require 'async-chainable'
path = require 'path'
fs = require 'fs'

#
# Project
debug = require('debug')('gastropod/core/swig/loaders/multipath')


class MultiPathFsLoader

	constructor: (sources=[], encoding='utf-8')->
		@options =
			sources: sources
			encoding: encoding
			cwd: process.cwd()

		debug 'New loader', @options

		# loop over sources
		# check for existance:
		# 	- is it a path?
		# 	- is it an npm module name?
		# 		- resolve `config.patternlab` to absolute path

	###*
	 * Resolves `identifier` to an absolute path or unique identifier. This is used for building correct, normalized, and absolute paths to a given template.
	 * @param  {String} identifier Non-absolute identifier or pathname to a file
	 * @param  {String} from       If given, should attempt to find the to path in relation to this given, known path.
	 * @return {String}            correct normalised and absolute paths to templates
	###
	resolve: (identifier, from)->
		return identifier

	loadAsync: (identifier, done)->
		encoding = @options.encoding
		async()
			.each @options.sources, (location, next)->
				filename = path.join location, identifier
				fs.exists filename, (exists)->
					if exists
						fs.readFile(identifier, encoding, done)
					else
						next()

			.end (err)->
				debug "couldn't find", identifier
				done(err)

	loadSync: (identifier)->
		encoding = @options.encoding
		@options.sources.forEach (location)->
			filename = path.join location, identifier
			if fs.existsSync filename
				debug 'found', filename
				return fs.readFileSync filename, encoding
		debug "couldn't find", identifier
		return "<!-- missing template #{identifier} //-->"

	###*
	 * Loads a single template. Given a unique identifier found by the resolve method this should return the given template.
	 * @param  {String}   identifier Unique identifier of a template (possibly an absolute path).
	 * @param  {Function} done       Asynchronous callback function. If not provided, this method should run synchronously.
	 * @return {String}              Template contents
	###
	load: (identifier, done)->
		debug 'Loading', identifier
		if not done
			return @loadSync identifier
		else
			return @loadAsync identifier, done

module.exports = MultiPathFsLoader