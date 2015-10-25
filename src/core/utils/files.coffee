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
{pongular} = require 'pongular'
$Q = require 'bluebird'



#
# Exportable
pongular.module 'gastropod.core.utils.files', []
	.service 'FileService', [
		'isFile'
		'isDirectory'
		'pathExists'
		'fileMap'
		(isFile, isDirectory, pathExists, fileMap) ->
			isFile: isFile
			isDirectory: isDirectory
			pathExists: pathExists
			fileMap: fileMap
	]

	.factory 'isFile', ->
		(filepath)->
			try
				return fs.statSync(filepath).isFile()
			catch err
				return false

	.factory 'isDirectory', ->
		(filepath)->
			try
				return fs.statSync(filepath).isDirectory()
			catch err
				return false

	.factory 'pathExists', ->
		(filepath)->
			return exports.isDirectory(filepath) or exports.isFile(filepath)

	.factory 'CollectFiles', ->
		(dirname='./', pattern='**', options={})->
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

	.factory 'fileMap', ->
		(pattern='**', root='./', ignore=null)->
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
					output[fileKey] = filePath

			return output

