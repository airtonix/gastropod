#
# Framework
{pongular} = require 'pongular'
debug = require('debug')('gastropod/core/templates')

#
# Exportable
pongular.module 'gastropod.core.templates', [
	'gastropod.config'
	'gastropod.core.utils'
	'gastropod.core.templates.context'
	'gastropod.core.templates.swig'
	]

	.service 'TemplateStore', [
		'fileMap'
		'ConfigStore'
		(fileMap, Config)->
			debug 'Config.filters.patterns', Config.filters.patterns
			# return fileMap Config.filters.patterns, root, ['pages/**/*']
	]