#
# Framework
debug = require('debug')('gastropod/core/templates/tags/static')

#
# Constants
REGEX_EXTERNAL_URL = /^(https?:\/\/|\/\/|#)/


module.exports =
	ext:
		name: 'debug'
		obj: debug

	parse: (str, line, parser, types, stack, options)->
		return true

	compile: (compiler, args, content, parents, options, blockName)->

		"""(function() {
			var url = #{args[0]};
			var urls = _ctx.Site && _ctx.Site.urls || null;
			var static, manifest, root;
			var manifest = _ctx.Manifest || {};

			if (urls) {
				static = urls.static || null;
				root = urls.root || null;
			}

			if(!static || !root){
				_output += url;
				return;
			}

			if (!url.match(#{REGEX_EXTERNAL_URL})) {
				_ext.debug('found match ', url);

				if(root.length === 1 && root.indexOf('/') === 0){
					root = '';
				}

				if(static.indexOf('/') === 0){
					static = static.substring(1);
				}

				if(url.indexOf('/') === 0){
					url = url.substring(1);
				}

				url = manifest[url] || url;
				_output += [root, static, url].join('/');
			} else {
				_output += url;

			}
			return
		})();"""
