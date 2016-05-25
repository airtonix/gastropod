#
# Framework
debug = require('debug')('gastropod/core/templates/tags/static')

# project
Manifest = require('gastropod/src/core/assets/manifest')

#
# Constants
REGEX_EXTERNAL_URL = /^(https?:\/\/|\/\/|#)/


module.exports =
	ext:
		name: 'Manifest'
		obj: Manifest.db

	parse: (str, line, parser, types, stack, options)->
		return true

	compile: (compiler, args, content, parents, options, blockName)->

		"""(function() {
			var url = #{args[0]};
			var urls = _ctx.Site && _ctx.Site.urls || null;
			var static, manifest, root;
			var manifest = _ext.Manifest;

			if (urls) {
				static = urls.static || null;
				root = urls.root || null;
			}

			if(!static || !root){
				_output += url;
				return;
			}

			if (!url.match(#{REGEX_EXTERNAL_URL})) {

				if(root.length === 1 && root.indexOf('/') === 0){
					root = '';
				}

				if(static.indexOf('/') === 0){
					static = static.substring(1);
				}

				if(url.indexOf('/') === 0){
					url = url.substring(1);
				}

				var inManifest = manifest[url] && true;
				console.log(url, inManifest, manifest);

				url = inManifest && manifest[url] || url;

				_output += [root, static, url].join('/');

			} else {
				_output += url;

			}
			return
		})();"""
