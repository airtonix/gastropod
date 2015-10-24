#
# System
path = require 'path'

#
# Framework
nconf = require 'nconf'
_ = require 'lodash'
{pongular} = require 'pongular'
debug = require('debug')('gastropod/config')


pongular.module 'gastropod.config', [
	'gastropod.config.defaults'
	]

	.constant 'PackageJson', require(path.join(process.cwd(), 'package.json'))

	.provider 'ConfigStore', [
		'DefautConfig'
		'PackageJson'
		(DefautConfig, PackageJson)->

			nconf.use 'memory'
			nconf.argv()
			nconf.env match: /^gastropod__(.*)/

			add = (key, value)->
				debug 'adding', key
				nconf.add key, type: 'literal', store: value

			init = (options)->
				projectConfigPath = path.resolve(options.config)

				try
					add 'project', require projectConfigPath
				catch err
					debug 'missing ', projectConfigPath

			add 'defaults', DefautConfig

			return {
				init: init
				add: add
				$get: -> nconf.get()
			}
	]
