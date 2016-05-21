exec = require('child_process').execFileSync
slug = require 'slug'

module.exports =
	describe: ->
		slug exec('git', ['describe', '--tags', '--long']).toString()
	branch: ->
		slug exec('git', ['rev-parse', '--abbrev-ref', 'HEAD']).toString()
	commit: ->
		slug exec('git', ['rev-parse', 'HEAD']).toString()

