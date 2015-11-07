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
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'

#
# Exportable
module.exports = ()->
	port = process.env.PORT
	app = express()

	app.set 'staticRoot', path.join(process.cwd(), Config.target.root)
	app.use serve app.get 'staticRoot'

	async()
		.then 'port', (next)->
			if 'PORT' in Object.keys(process.env)
				debug 'using defined port', port
				next null, port

			else
				getport next

		.then (next)->
			app.listen @port, next

		.end (err)->
			util.log "serving #{app.get('staticRoot')}\n\t on http://0.0.0.0:#{@port}"
