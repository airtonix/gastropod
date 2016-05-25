path = require('path')
should = require('chai').should()


Config = require('../src/config')
Defaults = require('../src/config/defaults')


describe 'Config', ->

	it 'Default configuration present', (done) ->
		Config()

		Config.Store.pipeline
			.should.be.an('object')
			.and.deep.equal(Defaults.pipeline)

		Config.Store.target
			.should.be.an('object')
			.and.deep.equal(Defaults.target)

		Config.Store.source
			.should.be.an('object')
			.and.deep.equal(Defaults.source)

		Config.Store.plugins
			.should.be.an('object')
			.and.deep.equal(Defaults.plugins)

		done()

	it 'Layers environment configuration files', (done) ->

		Config {
			config: './test/project/config/config.develop.json'
		}

		Config.Store.target
		 	.should.be.an('object')
			.and.to.have.property('root', './dist/develop')

		done()
