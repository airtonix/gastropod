Manifest = require '../core/assets/manifest'

module.exports = ()->
	return Manifest.db

exports['@singleton'] = true
