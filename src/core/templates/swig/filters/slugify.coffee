#
# Framework
slug = require 'slug'
debug = require('debug')('gastropod/core/templates/filters/slugify')


module.exports = (input) ->
	slug input, lower: true
