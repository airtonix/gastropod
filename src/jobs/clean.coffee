#
# Framework
debug = require('debug')('gastropod/jobs/clean')
gulp = require 'gulp'

#
# Project
{Config} = require('../config')
Plugins = require '../plugins'

#
# Exportable
gulp.task 'clean', [ 'clean:scripts', 'clean:styles', 'clean:copies', 'clean:pages']
