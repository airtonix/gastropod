ContentTree = require 'content-tree'
QueryEngine = require 'query-engine'
traverse = require 'traverse'


module.exports = (path)->
	reducer = (accumulator, item)->
		if @isLeaf
			accumulator.push item
		return accumulator

	models = ContentTree(path)
		.generate()
		.then (tree)->
			traverse tree
				.reduce reducer, []

	QueryEngine
		.createLiveCollection models
		.createLiveChildCollection()
		.setPill 'id',
			prefixes: ['id:']
			callback: (model, value)-> model.get('id') is parseInt(value, 10)

		.setPill 'basename',
			prefixes: ['basename:']
			callback: (model, value)->
				searchRegex = QueryEngine.createSafeRegex value
				return searchRegex.test model.get 'basename'

		.setPill 'mime',
			prefixes: ['mime:']
			callback: (model, value)->
				searchRegex = QueryEngine.createSafeRegex value
				return searchRegex.test model.get 'mimeType'

		.query()