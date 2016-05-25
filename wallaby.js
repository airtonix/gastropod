module.exports = function (wallaby) {

	return {

		files: [
			'src/**/*.coffee',
			'test/project/**/*'
		],

		tests: [
			'test/**/test\.**.coffee'
		],

		env: {
			type: 'node',
			runner: 'node'
		}

	};

};