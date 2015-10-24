#
# Framework
{pongular} = require 'pongular'
debug = require('debug')('gastropod/core/templates/tags/media')

#
# Constants
REGEX_EXTERNAL_URL = /^(https?:\/\/|\/\/|#)/

pongular.module 'gastropod.core.templates.swig.tags.media', [
	'gastropod.core.templates.swig.configurator'
]

	.run [
		'SwigConfig'
		(SwigConfig)->

			SwigConfig.addTag 'media', {
				parse: (str, line, parser, types, stack, options)->
					return true

				compile: (compiler, args, content, parents, options, blockName)->

					"""(function() {
						var url = #{args[0]};
						var urls = _ctx.Site && _ctx.Site.urls || null;
						var media, root;

						if (urls) {
							media = urls.media || null;
							root = urls.root || null;
						}

						if(!media || !root){
							_output = url;
							return;
						}

						if (!url.match(#{REGEX_EXTERNAL_URL})) {

							if(root.indexOf('/') == 0){
								root = root.substring(1);
							}
							if(media.indexOf('/') == 0){
								media = media.substring(1);
							}
							if(url.indexOf('/') == 0){
								url = url.substring(1);
							}

							_output += [root, media, url].join('/');

						} else {
							_output += url;

						}
						return
					})();"""
			}
	]
