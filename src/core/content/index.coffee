#
# System
#
fs = require('fs')
path = require('path')

#
# Framework
#
_ = require 'lodash'
ContentTree = require 'content-tree'
traverse = require 'traverse'
debug = require('debug')('gastropod/core/content')
Backbone = require 'backbone'
{QueryCollection} = require 'backbone-query'
{pongular} = require 'pongular'



class FileModel extends Backbone.Model


###*
 * ContentTree
###
class ContentService

	db: null

	empty: ->
		@db = null

	query: (query={})->
		@db.query query

	generate: (source, done)->
		debug 'Creating content-tree from', source
		models = []

		ContentTree(source)
			.on 'file', (file)->
				model = new FileModel file
				debug 'adding file to models', file.path
				models.push model

			.generate (tree)->
				@db = new QueryCollection models
				debug 'Collection created', @db.length
				done()

#
# Exportable
pongular.module 'gastropod.core.content', []

	.service 'ContentService', -> new ContentService()

	.factory 'ContentStore', [
		'ContentService'
		(ContentService)->
			return ContentService.db
	]