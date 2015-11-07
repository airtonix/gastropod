#
# System
#
fs = require('fs')
path = require('path')

#
# Framework
#
debug = require('debug')('gastropod/tasks/collection')
gulp = require 'gulp'
_ = require 'lodash'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'
ContentCollection = require '../core/content'


gulp.task 'collection', (done)->
	debug 'building collection', ContentCollection.db

	Content.empty()
	Content.generate pages, ()->
		debug 'content colletion generated'
		done()

	return
