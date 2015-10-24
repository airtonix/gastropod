#
# System
path = require 'path'

#
# Framework
_ = require 'lodash'
{pongular} = require 'pongular'
debug = require('debug')('gastropod/core/plugins')

#
# Exportable
pongular.module 'gastropod.plugins.fingerprinter', [
	'gastropod.plugins.vendor'
	'gastropod.core.assets.hasher'
	'gastropod.core.assets.replacer'
	]

	.factory 'PluginFingerprint', [
		'PluginCollectionVendor'
		'AssetHasher'
		'AssetReferenceReplacer'
		(PluginCollectionVendor, Hasher, Replacer)->
			new PluginCollectionVendor.revAll
				debug: true
				transformFilename: Hasher
				replacer: Replacer
	]