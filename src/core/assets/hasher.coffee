#
# System
#
path = require 'path'

#
# Framework
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.core.assets.hasher', []
	.factory 'AssetHasher', ->

		###*
		 * [hasher description]
		 * @param  {[type]} file [description]
		 * @param  {[type]} hash [description]
		 * @return {[type]}      [description]
		###
		(file, hash)->
			ext = path.extname(file.path)
			output = hash.substr(0, 5) + '.'  + path.basename(file.path, ext) + ext
			return output
