#
# System
path = require 'path'

#
# Framework
{pongular} = require 'pongular'


#
# Exportable
pongular.module 'gastropod.core.assets.replacer', []
	.factory 'AssetReferenceReplacer', ->

		###*
		 * [hasher description]
		 * @param  {[type]} file [description]
		 * @param  {[type]} hash [description]
		 * @return {[type]}      [description]
		###
		(fragment, replaceRegExp, newReference, referencedFile)->
			regExp = replaceRegExp
			root = path.resolve options.source.root
			referencedFilePath = referencedFile.path.replace root + '/', ''
			reference = referencedFilePath.replace /([\d\w]+\.)/, ''

			fragment.contents = fragment.contents.replace reference, newReference
