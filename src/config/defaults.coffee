path = require 'path'

###*
 * Asset Pipeline Spec
 * -------------------
 * @work_in_progress
 * - Allows you to override the default order of
 *   tasks for specific jobs
 * - you could for example, change it to `['jade']`, or  `['handlebars']`
 *   But, you would of course be required to provide those tasks.
###
defaultPipeline =
	templates: ['swig']
	scripts: ['browserify']
	styles: []
	copy: ['copy:extras']
	docs: ['docjs']

###*
 * Filters to dictate what files to operate on
###
defaultFilters =
	all: '**/*.*'
	data: '**/*.{litcoffee,coffee,json,yml}'
	fonts: '**/*.{otf,ttf,eot,woff}'
	images: '**/*.{png,jpg,jpeg,gif,bmp,svg,apng}'
	styles: '**/*.{scss,css}'
	scripts:
		all: '**/**.{js,coffee,litcoffee}'
		modules: '**/{app,*-module,main}.{js,coffee,litcoffee}'
	patterns: '**/*.html'
	tests:
		e2e: '**/*.e2e.{js,coffee}'
		unit: '**/*.unit.{js,coffee}'

###*
 * List of targets for various jobs
 * `target.root` is prepended to each of the
 * others listed here
###
defaultTarget =
	root: './dist/default'
	static: './static'
	data: './data'
	fonts: './fonts'
	images: './images'
	styles: './styles'
	scripts: './scripts'
	docs: './docs'
	pages: '' # target root is the site root

###*
 * List of source paths
 * again, `source.root` is prepended to each
###
defaultSource =
	root: './src'
	data: './data'
	images: './images'
	styles: './styles'
	scripts: './scripts'
	pages: './patterns/pages'
	tests: './tests'
	patterns: [
		'./src/patterns',
	]

# src is relative to defaultSource.root
# target is relative to defaultTarget.root
defaultCopy = [
	{src: path.join('fonts', defaultFilters.fonts), dest: './static/fonts'}
	{src: path.join('images', defaultFilters.fonts), dest: './static/images'}
]

###*
 * Default template context
 * - certain values here are expected for
 *  various template pipelines:
 *    - swig expects the `site.urls` tree just as it is here
 *    - swig static and media tags will join
 *    `site.urls.root` + `site.urls.[static|media]` with
 *    the supplied path.
###
defaultContext =
	site:
		title:  "Untitled Website"
		description: "A gastronically developed website"
		owner:
			name: "You"
			email: "e@ma.il"
		urls:
			root: "//localhost"
			static:  '/static'
			media:  '/media'

	###*
	 * Template context for modules
	###
	modules: {
		# analytics:
		# 	google:
		# 		code: 'UA-12345678-1'
		# 		domain: 'YOUR_DOMAIN'

		# disqus:
		# 	shortname: 'YOUR_DISQUS_SHORTNAME'
	}

###*
 * Gulp plugin options
 * Define the options for each of the pipeline tasks here
###

###*
 * gulp-git-pages
 * https://www.npmjs.com/package/gulp-git-pages#api
 * @type {Object}
###
defaultDeployOptions = {
	# remoteUrl: 
}

###*
 * Asset Fingerprinting
 * @affects swig.tags.media
 * @affects swig.tags.static
 * @type {Object}
###
defaultPluginFingerPrinter =
	scripts: true
	styles: true
	images: true
	fonts: true

###*
 * Minification
 * @type {Object}
###
defaultPluginMinify =
	scripts: false

###*
 * HtmlPrettify
###
defaultPluginPrettify =
	indent_char: ' '

###*
 * Browserify Settings
 * @affects task:browserify
###
defaultPluginJs =
	browserify:
		debug: true
		transforms:
			nghtml2js: module: 'templates'

###*
 * node-sass
 * @affects task:scss
###
defaultPluginCss =
	sass:
		errLogToConsole: true
		includePaths: [
		]

###*
 * BrowserSync
 * @affects job:server
###
defaultPluginServer =
	open: false
	notify: false


###*
 * Documentation
###
defaultPluginDocumentation = {}

#
# Export the default configuration
#
module.exports =
	pipeline: defaultPipeline
	filters: defaultFilters
	source: defaultSource
	target: defaultTarget
	context: defaultContext
	watch: false
	plugins:
		copy: defaultCopy
		prettify: defaultPluginPrettify
		fingerprint: defaultPluginFingerPrinter
		minify: defaultPluginMinify
		documentation: defaultPluginDocumentation
		js: defaultPluginJs
		css: defaultPluginCss
		server: defaultPluginServer
