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

At the moment it has tasks packaged with it, which will in time be extracted and distributed as separate modules.


### Remove Old Files

Uses `viny-paths` and `del`

### Compile New Files

Styles, scripts and copying of extra files

*todo*: generate font-icons


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
