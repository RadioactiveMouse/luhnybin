hideCreditCards = require('./lib').hideCreditCards

# run the app
process.stdin.resume()
process.stdin.setEncoding 'ascii'
process.stdin.on 'data', (data) ->
	tests = data.split '\n'
	
	for test in tests
		console.log hideCreditCards test
	
	return
