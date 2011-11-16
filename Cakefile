fs            = require 'fs'
path          = require 'path'
{spawn, exec} = require 'child_process'

# compile everything to JS.
task 'build', 'build the app', ->
	child = exec [
		'coffee -o build/ -bc index.coffee'
		'coffee -o build/lib/ -bc lib/'
		'coffee -o build/tests -bc tests/reissbaker/'
	].join(' && '), (err, stdout, stderr) ->
    if err then console.log stderr.trim() else console.log '-- Build finished succesfully. --'
	child.stdout.on 'data', (data) -> console.log data
