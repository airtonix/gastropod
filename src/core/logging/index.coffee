###*
 * Logger
###

#
# System
#
path = require 'path'

#
# Framework
#
_ = require 'lodash'
through = require 'through2'
util = require 'gulp-util'
prettyBytes = require 'pretty-bytes'
{pongular} = require 'pongular'


class Logger

	@levels =
		info: util.colors.white
		warn: util.colors.yellow
		error: util.colors.red

	constructor: (@name)->

	@spawn = (name)->
		return new Logger(name)

	spawn: (name)->
		Logger.spawn "#{@name}/{name}"

	through: (level, itemTpl="<%= file.relative %>", collectionTpl="<%= count %> items.")->
		@level = level
		@itemTpl = _.template itemTpl
		@collectionTpl = _.template collectionTpl
		count = 0

		item = (file, enc, done)=>
			count++
			file.size = prettyBytes String(file.contents).length
			@msg util.colors.grey @itemTpl file: file
			done(null, file)

		end = (done)=>
			@msg util.colors.grey @collectionTpl count: count
			count = null
			done()

		return through.obj item, end

	msg: (args...)=>
		bits = [
			util.colors.cyan @name
		]
		for bit in args
			bits.push bit

		util.log.apply util.log, bits

	incoming: ()->
		@through('info', "#{util.colors.white('<--')} <%= file.relative %>")

	outgoing: ()->
		@through('info', "#{util.colors.white('-->')} <%= file.relative %> [<%= file.size %>]")

	info: (itemTemplate, collectionTemplate)->
		@through('info', itemTemplate, collectionTemplate)

	error: (itemTemplate, collectionTemplate)->
		@through('error', itemTemplate, collectionTemplate)

	warn: (itemTemplate, collectionTemplate)->
		@through('warn', itemTemplate, collectionTemplate)


#
# Exportable
pongular.module 'gastropod.core.logging', []

	.factory 'Logger', -> Logger

	.factory 'ErrorHandler', ->
		(name)->
			name = util.colors.red "[#{name}]"
			(err)->
				util.log name, err
				@emit 'end'
