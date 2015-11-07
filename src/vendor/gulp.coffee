#
# Framework
gulp = require 'gulp'
postmortem = require 'postmortem'

#
# Exportable
gulp.on 'error', (err)->
	postmortem.prettyPrint err
