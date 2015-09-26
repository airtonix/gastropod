#
# System
#
_ = require 'lodash'
path = require 'path'


module.exports = (fragment, replaceRegExp, newReference, referencedFile)->
	regExp = replaceRegExp
	root = path.resolve options.source.root
	referencedFilePath = referencedFile.path.replace root + '/', ''
	reference = referencedFilePath.replace /([\d\w]+\.)/, ''

	fragment.contents = fragment.contents.replace reference, newReference
