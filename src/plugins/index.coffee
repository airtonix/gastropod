#
# Framework
{pongular} = require 'pongular'
debug = require('debug')('gastropod/plugins')


#
# Exportable
pongular.module 'gastropod.plugins', [
	'gastropod.plugins.vendor'
	'gastropod.plugins.swig'
	'gastropod.plugins.fingerprinter'
	]

	.factory 'PluginService', [
		'PluginCollectionVendor'
		'PluginSwig'
		'PluginFingerprint'
		(PluginVendors, PluginSwig, PluginFingerprint)->
			plugins = PluginVendors
			plugins.swig = PluginSwig
			plugins.fingerprint = PluginFingerprint

			debug 'loaded plugins', Object.keys plugins

			return plugins
	]


#
# Exportable
pongular.module 'gastropod.plugins.vendor', []

	.factory 'PluginCollectionVendor', [
		()->

			vendors = require('gulp-load-plugins')()
			vendors.through = require 'through2'
			vendors.throughPipes = require 'through-pipes'
			vendors.browserify = require 'browserify'
			vendors.source = require 'vinyl-source-stream'
			vendors.buffer = require 'vinyl-buffer'
			vendors.globby = require 'globby'
			vendors.transform = require 'vinyl-transform'
			vendors.runsequence = require 'run-sequence'
			vendors.browsersync = require('browser-sync').create()
			vendors.nghtml2js = require 'browserify-ng-html2js'
			vendors.del = require 'del'
			vendors.vinylPaths = require 'vinyl-paths'
			vendors.end = require 'stream-end'

			return vendors
	]

