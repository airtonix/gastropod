require('coffee-script/register');
module.exports = require('./src');
module.exports.Plugins = require('./src/plugins');
module.exports.Config = require('./src/config');
module.exports.Logging = require('./src/core/logging');
module.exports.Manifest = require('./src/core/assets/manifest');
