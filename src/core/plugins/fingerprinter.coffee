
#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'

#
# Project
#
hasher = require '../assets/manifest/hasher'
replacer = require '../assets/manifest/replacer'

###*
 * [Fingerprinter description]
###
module.exports = ($)->
	->
		new $.revAll
			debug: true
			transformFilename: hasher
			replacer: replacer