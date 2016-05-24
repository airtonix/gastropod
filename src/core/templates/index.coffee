#
# Framework
gulp = require 'gulp'
debug = require('debug')('gastropod/core/templates')

#
# Project
{fileMap} = require '../utils/files'
Config = require '../../config'
plugins = require '../../plugins'

root = Config.Store.source.patterns[0]
filter = Config.Store.filters.patterns
ignore = ['pages/**/*']

module.exports = fileMap(filter, root, ignore)
