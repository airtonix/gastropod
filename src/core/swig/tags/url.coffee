#
# System
#

#
# Framework
#

#
# Project
#

#
# Constants
REGEX_EXTERNAL_URL = /^(https?:\/\/|\/\/|#)/

module.exports =

	parse: (str, line, parser, types, stack, options)->
		return true

	compile: (compiler, args, content, parents, options, blockName)->

		"""(function() {
			var url = #{args[0]};
			var urls = _ctx.site && _ctx.site.urls || null;
			var manifest, root;
			var manifest = _ctx.manifest || {};

			if (urls) {
				root = urls.root || null;
			}

			if(!root){
				_output = url;
				return;
			}

			if (!url.match(#{REGEX_EXTERNAL_URL})) {
				url = manifest[url] || url;
				_output += root + media + url;

			} else {
				_output += url;

			}
			return
		})();"""
