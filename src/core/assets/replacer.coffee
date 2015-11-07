#
# System
path = require 'path'

###*
 * [hasher description]
 * @param  {[type]} file [description]
 * @param  {[type]} hash [description]
 * @return {[type]}      [description]
###
module.exports = (fragment, replaceRegExp, newReference, referencedFile)->
	regExp = replaceRegExp
	root = path.resolve options.source.root
	referencedFilePath = referencedFile.path.replace root + '/', ''
	reference = referencedFilePath.replace /([\d\w]+\.)/, ''

	fragment.contents = fragment.contents.replace reference, newReference
