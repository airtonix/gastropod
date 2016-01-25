#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/core/assets/replacer')
unixify = require 'unixify'

#
# Project
{Config} = require '../../config'
Manifest = require './manifest'


###*
 * [hasher description]
 * @param  {[type]} file [description]
 * @param  {[type]} hash [description]
 * @return {[type]}      [description]
###

module.exports = (fragment, replaceRegExp, newReference, referencedFile)->
	
	regExp = replaceRegExp
	root = unixify path.resolve Manifest.options.root
	refPath = unixify path.resolve referencedFile.path

	debug 'root:', root
	debug 'replacing:', newReference, refPath

	# attempt to remove the root from the path
	reference = refPath
		.replace(root, '')
		.replace(/^(\/|\\)+/, '')

	# replace reference with new filename
	result = fragment.contents.replace reference, newReference

	debug 'reference', reference

	fragment.contents = result
