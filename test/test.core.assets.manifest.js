require('coffee-script/register');

var Manifest = require('gastropod/src/core/assets/manifest'),
	Config = require('gastropod/src/config'),
	path = require('path'),
	should = require('chai').should();


describe('Core.Assets.Manifest', function () {

	it('ManifestService has expected initial state', function (done) {
		Manifest.should.have.a.property('db');
		Manifest.should.have.a.property('options');
		done();
	});


	it('Maintains a map of hashed assets', function (done) {
		Manifest.options.root = './build/develop';
		Manifest.add('./build/develop/static/scripts/foo.js', './build/develop/static/scripts/foo.2342j234.js');

		Manifest.db
			.should.be.an('object')
			.and.have.a.property('static/scripts/foo.js', 'static/scripts/foo.2342j234.js');

		done();
	});


	it('Allows external manipulation of map', function (done) {
		Manifest.options.root = './build/develop';
		Manifest.add('./build/develop/static/scripts/foo.js', './build/develop/static/scripts/foo.2342j234.js');
		Manifest.merge({
			"bar.js": "bar.2342j234.js"
		});

		Manifest.db
			.should.have.a.property('static/scripts/foo.js', 'static/scripts/foo.2342j234.js')
		Manifest.db
			.should.have.a.property("foo.js", "foo.2342j234.js")

		done();
	});


});