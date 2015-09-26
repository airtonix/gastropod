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

	through: (level, itemTpl, collectionTpl)->
		@level = level
		@itemTpl = _.template itemTpl
		@collectionTpl = collectionTpl and _.template @collectionTpl
		count = 0

		item = (file, enc, done)=>
			count++
			@msg util.colors.grey @itemTpl file: file
			done(null, file)

		end = (done)=>
			@msg util.colors.grey "#{count} items."
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

	info: (itemTemplate, collectionTemplate)->
		@through('info', itemTemplate, collectionTemplate)

	error: (itemTemplate, collectionTemplate)->
		@through('error', itemTemplate, collectionTemplate)

	warn: (itemTemplate, collectionTemplate)->
		@through('warn', itemTemplate, collectionTemplate)

module.exports = Logger