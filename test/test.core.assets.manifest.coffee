Config = require('../src/config')
Manifest = require('../src/core/assets/manifest')

path = require('path')
should = require('chai').should()


describe 'Core.Assets.Manifest', ->

	beforeEach (done) ->
		Manifest.empty()
		done()

	it 'ManifestService has expected initial state', (done) ->
		Manifest
			.should.have.a.property('db')
		Manifest
			.should.have.a.property('options')
		done()

	it 'Maintains a map of hashed assets', (done) ->
		Manifest
			.option 'root', './build/develop'
		Manifest
			.add('./build/develop/static/scripts/foo.js', './build/develop/static/scripts/foo.2342j234.js')
		Manifest.db
			.should.be.an('object')
			.and.have.a.property('static/scripts/foo.js', 'static/scripts/foo.2342j234.js')
		done()

	it 'Allows external manipulation of map', (done) ->
		Manifest
			.option 'root', './build/develop'
		Manifest
			.add('./build/develop/static/scripts/foo.js', './build/develop/static/scripts/foo.2342j234.js')
		Manifest.merge
			"bar.js": "bar.2342j234.js"
		Manifest.db
			.should.have.a.property('static/scripts/foo.js', 'static/scripts/foo.2342j234.js')
		Manifest.export()
			.should.have.a.property("bar.js", "bar.2342j234.js")
		done()

	it 'Cleans manifest', (done)->
		Manifest
			.option 'root', './build/develop'
		Manifest
			.add('./build/develop/static/scripts/foo.js', './build/develop/static/scripts/foo.2342j234.js')
		Manifest.db
			.should.have.a.property('static/scripts/foo.js', 'static/scripts/foo.2342j234.js')
		Manifest.empty()

		Object.keys Manifest.db
			.should.have.length(0)

		done()