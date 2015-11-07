#
# System
path = require 'path'

#
# Framework
debug = require('debug')('gastropod/tasks/images')
gulp = require 'gulp'
_ = require 'lodash'

#
# Projects
{Config} = require('../config')
Plugins = require '../plugins'
{ErrorHandler,Logger} = require '../core/logging'


logger = new Logger('deploy')
source = path.join(Config.target.root,
				   Config.filters.all)


gulp.task 'deploy:github-pages', (done)->
	debug 'source', source
	debug 'Starting'

	return gulp.src source
		.pipe logger.incoming()
		.pipe Plugins.plumber ErrorHandler('deploy:github-pages')
		.pipe Plugins.gitPages Config.deploy
		.pipe logger.outgoing()
		.on 'error', (err)-> debug err
		.on 'finish', ()-> debug "Finished"
