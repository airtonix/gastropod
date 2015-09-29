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
	styles: ['scss']

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
	pages: '' # target root is the site root

###*
 * List of source paths
 * again, `source.root` is prepended to each
###
defaultSource =
	root: './src'
	data: './data'
	fonts:
		internal: './fonts'
		vendor: './node_modules/ratchet/fonts'
	images: './images'
	styles: './styles'
	scripts: './scripts'
	patterns: './patterns'
	pages: './patterns/pages'

###*
 * Filters to dictate what files to operate on
###
defaultFilters =
	all: '**/*.*'
	data: '**/*.{coffee,json,yml}'
	fonts: '**/*.{otf,ttf,eot,woff}'
	images: '**/*.{png,jpg,jpeg,gif,bmp,svg,apng}'
	styles: '**/*.{scss,css}'
	scripts:
		all: '**/*.{js,coffee,litcoffee}'
		modules: '**/{app,*-module,main}.{js,coffee,litcoffee}'
	patterns: '**/*.html'

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
defaultPluginSass =
	errLogToConsole: true
	includePaths: [
		path.join __dirname, 'node_modlues', 'ratchet', 'sass'
		path.join __dirname, 'node_modlues', 'bourboun', 'sass'
	]

###*
 * BrowserSync
 * @affects job:server
###
defaultPluginServer =
	open: false
	server:
		notify: false

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
		fingerprint: defaultPluginFingerPrinter
		minify: defaultPluginMinify
		js: defaultPluginJs
		sass: defaultPluginSass
		server: defaultPluginServer
