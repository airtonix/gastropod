#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
debug = require('debug')('gastropod/core/templates/context')
postmortem = require 'postmortem'
deepmerge = require 'deepmerge'
requireUncached = require 'require-uncached'


###*
 * [TemplateContexter description]
 * @param {[type]} file [description]
###
class TemplateContextFactory

	@defaults =
		Manifest: {}
		Page: {}
		Meta: {}

	data: {}

	constructor: (data={}) ->
		@data = deepmerge data, @constructor.defaults

	add: (data)->
		@data = deepmerge @data, data

	empty: ()->
		@data = {}

	export: (file)=>
		output = @data

		directory = path.dirname file.path
		fileext = path.extname(file.path)
		filename = path.basename(file.path, fileext)
		filepath = path.join directory, filename
		output = deepmerge _.clone(@data), Meta: file.meta

		try
			pageFactory = requireUncached filepath
			page = pageFactory output
			debug 'Page:', filepath, '>', page

		catch err
			if not err.code is 'MODULE_NOT_FOUND'
				debug 'error importing', filepath
				postmortem.prettyPrint err
			page = {}

		debug 'Page:', filepath, '>', page
		output = _.extend output, Page: page

		return output


module.exports = TemplateContextFactory