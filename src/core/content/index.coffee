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

class FileModel extends Backbone.Model


module.exports = (contentPath, done)->
	debug 'Creating content-tree from', contentPath

	models = []

	ContentTree(contentPath)

		.on 'file', (file)->
			debug 'adding file to models', file.path
			models.push new FileModel file

		.generate ()->
			collection = new QueryCollection models
			debug 'Collection created', collection.length
			done null, collection
