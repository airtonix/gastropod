#
##
#
fs =require 'fs'
path = require 'path'

#
# Framework
#
_ = require 'lodash'
changeCase = require 'change-case'
debug = require('debug')('gastropod/core/utils/files')
glob = require "glob"


class Files

	@isFile = (filepath)->
		try
			return fs.statSync(filepath).isFile()
		catch err
			return false


	@isDirectory = (filepath)->
		try
			return fs.statSync(filepath).isDirectory()
		catch err
			return false


	@exists = (filepath)->
		return exports.isDirectory(filepath) or exports.isFile(filepath)

	constructor: (pattern='**', root='./', ignore=null)->
		output = {}
		globbed = glob.sync pattern,
			nodir: true
			cwd: path.resolve(root)
			ignore: ignore

		for item in globbed
			if not Files.isDirectory path.join(root, item)
				fileExt = path.extname(item)
				fileKey = changeCase.camelCase path.basename(item, fileExt)
				filePath = item.replace(/,/g, '/')
				debug 'template:', fileKey, ' > ', filePath
				output[fileKey] = filePath

		return output

module.exports = Files

