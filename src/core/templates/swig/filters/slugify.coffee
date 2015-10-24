#
# Framework
slug = require 'slug'
{pongular} = require 'pongular'
debug = require('debug')('gastropod/core/templates/filters/slugify')

#
# Constants
REGEX_EXTERNAL_URL = /^(https?:\/\/|\/\/|#)/

pongular.module 'gastropod.core.templates.swig.filters.slugify', [
	'gastropod.core.templates.swig.configurator'
]

	.run [
		'SwigConfig'
		(SwigConfig)->

			SwigConfig.addFilter 'slugify', (input) -> slug input, lower: true
	]