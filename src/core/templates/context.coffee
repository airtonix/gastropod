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


###*
 * [TemplateContexter description]
 * @param {[type]} file [description]
###
class TemplateContextFactory

	@defaults =
		manifest: {}
		page: {}
		meta: {}

	data: {}

	constructor: (data={}) ->
		@data = _.defaultsDeep data, @constructor.defaults

	add: (data)->
		@data = _.defaultsDeep @data, data

	export: (file)=>
		output = @data
		filebase = file.base
		fileext = path.extname(file.relative)
		filename = path.basename(file.relative, fileext)
		filepath = path.join filebase, filename

		debug 'attempting to load', filepath

		output = _.extend {}, @data, meta: file.meta

		try
			pageFactory = require(filepath)
			page = pageFactory output
			debug page

		catch err
			if not err.code is 'MODULE_NOT_FOUND'
				postmortem.prettyPrint err
			page = {}

		output = _.extend output, page: page

		return output


module.exports = TemplateContextFactory