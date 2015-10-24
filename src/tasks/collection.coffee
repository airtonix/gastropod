#
# System
#
fs = require('fs')
path = require('path')

#
# Framework
#
debug = require('debug')('gastropod/tasks/collection')
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.tasks.collection', [
	'gastropod.vendor.gulp'
	'gastropod.core.logging'
	'gastropod.core.content'
	'gastropod.plugins'
	'gastropod.config'
	]

	.run [
		'GulpService'
		'PluginService'
		'ConfigStore'
		'ContentService'
		'ErrorHandler'
		'Logger'
		(Gulp, Plugins, Config, Content, ErrorHandler, Logger)->


			pages = path.join(Config.source.root,
						  	  Config.source.pages)

			Gulp.task 'collection', (done)->
				debug 'building collection', ContentCollection.db

				Content.empty()
				Content.generate pages, ()->
					debug 'content colletion generated'
					done()

				return
	]