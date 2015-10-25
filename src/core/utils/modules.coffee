#
# Framework
{pongular} = require 'pongular'
$Q = require 'bluebird'
debug = require('debug')('gastropod/core/utils/modules')
requireUncached = require 'require-uncached'

pongular.module 'gastropod.core.utils.modules', []

	.factory 'UncacheModule', [
		()->
			(modulePath)->
				debug 'uncaching module:', modulePath
				# module.children = module.children.filter (child)->
				# 	child.id not require.resolve(_module)

				# Object
				# 	.keys(module.constructor._pathCache)
				# 	.forEach(function(cacheKey) {
				# 		if ( cacheKey.indexOf(moduleName) > -1 ) {
				# 			delete module.constructor._pathCache[ cacheKey ];
				# 		}
				# 	});

				return requireUncached modulePath
	]

