path = require 'path'


target =
	root: './dist/default'
	data: './data'
	fonts: './fonts'
	images: './images'
	styles: './styles'
	scripts: './scripts'
	pages: '' # target root is the site root

source =
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

filters =
	all: '**/*.*'
	data: '**/*.{coffee,json,yml}'
	fonts: '**/*.{otf,ttf,eot,woff}'
	images: '**/*.{png,jpg,jpeg,gif,bmp,svg,apng}'
	styles: '**/*.{scss,css}'
	scripts:
		all: '**/*.{js,coffee,litcoffee}'
		modules: '**/{app, *-module}.{js,coffee,litcoffee}'
	patterns: '**/*.html'



pluginFingerPrinter =
	scripts: true
	styles: true
	images: true
	fonts: true


pluginMinify =
	scripts: false


pluginJs =
	browserify:
		debug: true

pluginSass =
	errLogToConsole: true
	includePaths: [
		path.join __dirname, 'node_modlues', 'ratchet', 'sass'
		path.join __dirname, 'node_modlues', 'bourboun', 'sass'
	]

pluginServer =
	open: false
	server:
		baseDir: target.root
		notify: false


module.exports =

	filters: filters
	source: source
	target: target
	plugins:
		fingerprint: pluginFingerPrinter
		minify: pluginMinify
		js: pluginJs
		sass: pluginSass
		server: pluginServer
