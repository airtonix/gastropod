var gastropod = require('../'),
	assert = require('assert');


describe('Config', function(){

	it('Default configuration present', function(){
		assert.equal(gastropod.config.defaults);
	});

	it('Layers environment configuration files');
	it('Live reloading of configuration');
});