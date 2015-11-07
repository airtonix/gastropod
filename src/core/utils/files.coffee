#
# System
fs =require 'fs'
path = require 'path'

#
# Framework
_ = require 'lodash'
changeCase = require 'change-case'
debug = require('debug')('gastropod/core/utils/files')
glob = require "glob"
$Q = require 'bluebird'

#
# Exportables
exports.isFile = isFile = (filepath)->
	try
		return fs.statSync(filepath).isFile()
	catch err
		return false

exports.isDirectory = isDirectory = (filepath)->
	try
		return fs.statSync(filepath).isDirectory()
	catch err
		return false

exports.pathExists = pathExists = (filepath)->
	return isDirectory(filepath) or isFile(filepath)

exports.CollectFiles = CollectFiles = (dirname='./', pattern='**', options={})->
	defaults =
			cwd: path.resolve(dirname)
			nodir: true

	options = _.extend {}, defaults, options
	debug 'globbing files:', dirname, pattern
	promise = new $Q (resolve, reject)->
		glob pattern, options, (err, files)->
			if err
				return reject(err)
			else
				return resolve(files)

	return promise

exports.fileMap = fileMap = (pattern='**', root='./', ignore=null)->
	output = {}
	globbed = glob.sync pattern,
		nodir: true
		cwd: path.resolve(root)
		ignore: ignore

	for item in globbed
		if not isDirectory path.join(root, item)
			fileExt = path.extname(item)
			fileKey = changeCase.camelCase path.basename(item, fileExt)
			filePath = item.replace(/,/g, '/')
			output[fileKey] = filePath

	return output

