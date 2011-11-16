hideCreditCards = require('./lib').hideCreditCards

# run the app
input = ''
process.stdin.resume()
process.stdin.setEncoding 'ascii'
process.stdin.on 'data', (data) ->
	input += data
	tests = input.split '\n'

	lastTest = tests[tests.length - 1]
	input = if lastTest.charAt(lastTest.length - 1) != '\n' then tests.pop() else ''

	for test in tests
		console.log hideCreditCards test
	
	return
