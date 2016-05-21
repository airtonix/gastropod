require('coffee-script/register');

var Config = require('gastropod/src/config'),
	path = require('path'),
	should = require('chai').should();

var defaults = require('../src/config/defaults');


describe('Config', function(){

	it('Default configuration present', function (done) {
		var config = Config();

		config.pipeline
			.should.be.an('object')
			.and.deep.equal(defaults.pipeline);
		config.target
			.should.be.an('object')
			.and.deep.equal(defaults.target);
		config.source
			.should.be.an('object')
			.and.deep.equal(defaults.source);
		config.plugins
			.should.be.an('object')
			.and.deep.equal(defaults.plugins);

		done();
	});

	it('Layers environment configuration files', function (done) {
		var config = Config({
				config: './test/project/config/config.develop.json'
			});

		config.target
		 	.should.be.an('object')
			.and.to.have.property('root', './dist/develop')

		done();
	});


});