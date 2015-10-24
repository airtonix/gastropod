
#
# Framework
{pongular} = require 'pongular'
swig = require 'swig'

#
# Exportable
pongular.module 'gastropod.core.templates.swig.loaders', [
	'gastropod.core.templates.swig.loaders.fs'
	]

#
# Exportable
pongular.module 'gastropod.core.templates.swig.loaders.fs', []

	.factory 'SwigLoaderFs', ->
		(sources, encoding)->
			return swig.loaders.fs(sources, encoding)
