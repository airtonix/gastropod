#
# System
#
fs = require('fs')
path = require('path')

#
# Framework
#
ContentCollection = require '../core/content'
debug = require('debug')('gastropod/tasks/collection')


module.exports = (gulp, $, config)->


	pages = path.join(config.source.root,
				  	  config.source.pages)

	gulp.task 'collection', (done)->
		debug 'building collection', ContentCollection.db

		ContentCollection.empty()
		ContentCollection.generate pages, ()->
			debug 'content colletion generated'
			done()

		return
