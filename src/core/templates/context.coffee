#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'

###*
 * [TemplateContexter description]
 * @param {[type]} file [description]
###
class TemplateContextFactory

	@defaults =
		manifest: {}
		document: {}

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

		try
			delete require.cache[require.resolve(filepath)]
			page = require filepath
			output = _.merge({}, @data, { page: page })
		catch err

		return output


module.exports = TemplateContextFactory