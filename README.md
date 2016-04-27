# Gastropod

Static site generator that allows for implementation of patternlab using gulp.

Gastropod is split into two levels of tasks in its approach to generating static sitesl Jobs and Tasks.

The general job flow goes like this:

1. Remove old files
2. Compile new files
    1. compile styles
    2. compile scripts
    3. copy extra files
3. Generate a fingerprint manifest
4. Compile pages
5. Serve the compiled files locally for development
6. Watch for changes and run relevant tasks again.


The goal of Gastropod is to be flexible about what tasks you want in your job pipelines.

By default, gastropod ships with a basic job pipeline, which includes:

- scripts: using `gulp-browserify`
- clean: using `del`
- asset fingerprinting: using `gulp-rev-all`
- local http server: using `browser-sync`
- template processing: using swig
- template context: using `zen-injector`


Other major tasks you'd want for the job pipeline are:

- gastropod-task-sass
- gastropod-task-webpack


# Usaage

```
$ npm i gastropod --save
```

in your `package.json`

```
...
"scripts": {
    "start": "gastropod run default --config=config/development",
    "build": "gastropod run default --config=config/build"
}
...
```

# Configuration

Create a directory of environment config files under your project somewhere, following the above npm scripts: `<project-root>/config/*.js|coffee`. For an example of a config file see `config/master.coffee`.

These config files will be named after the environment target you want to configure for.

# Addons

Eventually the idea is that Gastropod will merely clean and copy files as a default.

Specialised compiling will be handled by `gastropod-task-*` modules installed with npm into your project.

These "addons" are recognised by gastropod by the `keyword` key in their `package.json`.

Having them installed and thair task expressed in your `config.pipeline.*` array is enough to activate them:

```
$ ls -a ./node_modules/ | grep gastro
gastropod
gastropod-task-webpack
```

```
config.pipeline = {
    ...
    scripts: ['webpack']
    ...
}
```

# Templates: Patterns

Gastropod will make available to any plugin a compiled list of patterns:
It does this by looking in `config.source.patterns` and generate a list of templates as a flat key/value store.

It's worth noting that despite your folder structure for patterns, these filenames should
be unique through out the patterns. This excludes the `config.source.pages` directory.

A file named `patterns/molecules/forms/fieldset.html` will be available on the injected
module `Templates` as `Templates.fieldset`.

# Templates: Pages

The page templates and its directory structure reflect the output site structure. Any sitemap, site
navigation planning, url structure for seo purposes should be heavily considered here.

Gastropod will process each file found by recursively walking the `config.source.pages` directory,
rendering it with the Swig task.

For every file found, the task looks for an similary named associated context file for only this page.
So if you have a file named `patterns/pages/about/index.html` the task will look for
`patterns/pages/about/index.{coffee, js}`. Associated context files are processed as `zen-injector`
modules and thus enjoy the benefit of dependancy injection. See next section `Template Context`.

The Resulting output is rendered to `config.target.root`

## Templates: Context

For the oppurtunity to construct and reuse your patterns, any javascript or coffeescript found next to a template
matching its filename will be processed through imports and treated as a `zen-injector` module.

Perhaps you have `patterns/pages/about.html` and `patterns/pages/about.coffee`, consider the following:

```coffee
# patterns/pages/about.coffee

module.exports = (Templates, Site, Assets) ->

		Buttons =
			email:
				template: Templates.buttonLink
				data:
					text: 'Email Me'
					alt: 'you should put better text here.'
					url: 'mailto://e@ma.il'

		Blocks =
			hero:
				template: Templates.heroBlock
				data:
					title: 'Totally email me...'
					isSecondary: true
					buttons: [
						Buttons.email
					]

		Layouts =
			hero:
				template: Templates.layoutOneColumn
				data:
					columns:
						one: [
							Blocks.hero
						]

		Segments =
			hero:
				template: Templates.hero
				data:
					layouts: [
						Layouts.hero
					]

    return {
    	Title: 'The Page Title'
    	Segments: [
    		Segments.hero
    	]
    }
```

The page is provided a context variable of `Page`, which will be somewhat like:

```json
{
	"Title": "The Page Title",
	"Segments": [
    { template: 'patterns/molecules/layouts/layout.one-column.html', data: {
      columns: {
         one: [
           ... ad nauseum
         ]
    	}
    }}
	]
}
```

Astute observers will note a few things:
- The context file is exporting a function. This is what is given to `zen-injector` to have it's signature processed for known module names.
	- These module names can come from `config.source.data` which is a globally available source of data. This is the source of `Site`, a file named
	`data/Site.coffee`, which itself also exports a function for `zen-injector`.
- this data structure makes great use of the object orientated nature of swig templates (really any templating engine that is object orientated will work.... which means not handlebars or mustache).

### Inbuilt Context Modules

- `Templates`, composed before the template task is reached.
- `Manifest`, composed from the output of `styles`, `scripts`, `copy` job pipelines.
- `Pkg`, which is just your projects `package.json`

## Project Context Modules

These are context file you provide, which at the moment are any file found in `config.source.data` exposed as a modulename matching the filename.

# Swig Template Tags

Gastropod provides some useful template tags for working with assets:

- `{% media String %}` resolves String to a path under `config.Site.urls.root`/`config.Site.urls.media`
- `{% static String %}` resolves String to a path either found in the `Manifest` or just returns the provided string.