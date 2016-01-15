#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/core/plugins')
_ = require 'lodash'

#
# Project
revAll = require 'gulp-rev-all'
Hasher = require '../core/assets/hasher'
Replacer = require '../core/assets/replacer'


module.exports = ->
	new revAll
		debug: true
