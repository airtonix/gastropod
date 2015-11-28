#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/core/assets/replacer')

#
# Project
{Config} = require '../../config'

###*
 * [hasher description]
 * @param  {[type]} file [description]
 * @param  {[type]} hash [description]
 * @return {[type]}      [description]
###
module.exports = (fragment, replaceRegExp, newReference, referencedFile)->
	debug 'replacing:', newReference, referencedFile.path

	regExp = replaceRegExp
	root = path.resolve Config.source.root
	referencedFilePath = referencedFile.path.replace root + '/', ''
	reference = referencedFilePath.replace /([\d\w]+\.)/, ''

	fragment.contents = fragment.contents.replace reference, newReference
