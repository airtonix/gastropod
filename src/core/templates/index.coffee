#
# Framework
gulp = require 'gulp'
debug = require('debug')('gastropod/core/templates')

#
# Project
{fileMap} = require '../utils/files'
{Config} = require '../../config'
plugins = require '../../plugins'

root = Config.source.patterns[0]
filter = Config.filters.patterns
ignore = ['pages/**/*']

module.exports = fileMap(filter, root, ignore)
