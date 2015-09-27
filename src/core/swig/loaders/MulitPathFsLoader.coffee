###*
 * Allow loading templates from multiple silos of templates
 * 	- use case is to use NPM packages to store patternalbs of templates for specific
 * 	ui components:
 * 		- node_modules/fe-patternlab-stickyheader
 * 		- node_modules/fe-patternlab-forms
 * 		- node_modules/fe-patternlab-offcanvas-menu
 *
 * 
 * Where each modules package.json contains something like:
 *  ```
 * 	"patternlab": "./src/patterns"
 * 	```
 *
 * 
###

class MultiPathFsLoader

	constructor: (sources=[], encoding='utf-8')->
		@options =
			sources: sources
			encoding: encoding

		# loop over sources
		# check for existance:
		# 	- is it a path?
		# 	- is it an npm module name?
		# 		- resolve `config.patternlab` to absolute path

	###*
	 * Resolves `identifier` to an absolute path or unique identifier. This is used for building correct, normalized, and absolute paths to a given template.
	 * @param  {String} identifier Non-absolute identifier or pathname to a file
	 * @param  {String} from       If given, should attempt to find the to path in relation to this given, known path.
	 * @return {String}            correct normalised and absolute paths to templates
	###
	resolve: (identifier, from)->
		return identifier


	###*
	 * Loads a single template. Given a unique identifier found by the resolve method this should return the given template.
	 * @param  {String}   identifier Unique identifier of a template (possibly an absolute path).
	 * @param  {Function} done       Asynchronous callback function. If not provided, this method should run synchronously.
	 * @return {String}              Template contents
	###
	load: (identifier, done)->
		return """"""

module.exports = MultiPathFsLoader