
#
# Framework
swig = require 'swig'

#
# Exportable
module.exports = (sources, encoding)->
	return swig.loaders.fs(sources, encoding)
