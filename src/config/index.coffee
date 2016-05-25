#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/config')
nconf = require 'nconf'

#
# Constants
Defaults = require './defaults'

nconf.use 'memory'
nconf.argv()
nconf.env match: /^gastropod__(.*)/

layer = (source) ->
	debug 'Loading Layer: ', source
	layerPath = path.resolve(source)
	layerModule = require(layerPath)
	return layerModule


module.exports.Store = Store = {}
module.exports = (options = {}) ->

	environment = if options.config then layer(options.config) else {}
	nconf.overrides store: environment
	nconf.defaults store: Defaults
	module.exports.Store = Store = nconf.get()
	return Store
