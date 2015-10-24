#
# Framework
{pongular} = require 'pongular'

#
# Exportable
pongular.module 'gastropod.core.templates.swig', [
	'gastropod.core.templates.swig.configurator'
	'gastropod.core.templates.swig.tags'
	'gastropod.core.templates.swig.filters'
	'gastropod.core.templates.swig.loaders'
	]
