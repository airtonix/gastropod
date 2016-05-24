#
# System
fs = require 'fs'
path = require 'path'
util = require 'util'

#
# Framework
express = require 'express'
getport = require 'get-port'
serve = require 'serve-static'
async = require 'async-chainable'
debug = require('debug')('gastropod/core/server')

#
# Project
Config = require('../../config')
Plugins = require '../../plugins'
{ErrorHandler,Logger} = require '../logging'

#
# Exportable
module.exports = (config) ->

	async()
		.then 'app', (next)->
			app = config.app or express.createServer()
			next null, app

		.then 'root', (next)->
			root = path.join process.cwd(), Config.Store.target.root
			next(null, root)

		.then 'port', (next)->
			if 'PORT' in Object.keys(process.env)
				debug 'using defined port', port
				next null, port

			else if 'port' in config
				debug 'using configured port', config.port
				next null, config.port

			else
				getport next

		.then 'middleware', (next)->
			@app.use serve @root

			if config.middleware
				config.middleware.forEach (middleware)=>
					if middleware.hasOwnProperty(route)
						@app.use middleware.route, middleware.fn
					else
						@app.use middleware
			next()

		.then (next)->
			@app.listen @port, next

