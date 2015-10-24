#
# Framework
{pongular} = require 'pongular'
gulp = require 'gulp'
postmortem = require 'postmortem'

#
# Exportable
pongular.module 'gastropod.vendor.gulp', []

	.service 'GulpService', ->
		gulp.on 'error', (err)->
			postmortem.prettyPrint err

		return gulp
