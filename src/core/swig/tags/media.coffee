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
			var media, manifest, root;
			var manifest = _ctx.manifest || {};

			if (urls) {
				media = urls.media || null;
				root = urls.root || null;
			}

			if(!media || !root){
				_output = url;
				return;
			}
			if (!url.match(#{REGEX_EXTERNAL_URL})) {
				url = manifest[url] || url;
				_output += root + media + url;
				return

			} else {
				_output += url;

			}
			return
		})();"""
