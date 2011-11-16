vows = require 'vows'
assert = require 'assert'
luhnybin = require '../lib'

valid =
	pureDigits:
		'14':
			number:	'56613959932537'
			mask: 	'XXXXXXXXXXXXXX'
	dashes:
		'14':
			number:	'5-66139-59932-537'
			mask: 	'X-XXXXX-XXXXX-XXX'
	spaces:
		'14':
			number:	'566 13959 9325 37'
			mask: 	'XXX XXXXX XXXX XX'

invalid =
	pureDigits:
		'14':
			number: '49536290423965'
			mask: 	'49536290423965'

toArray = (string) ->
	for index in [0...string.length]
		string.charAt index

suite = vows.describe('Luhny Masking').addBatch
	'The Luhny test function':
		topic: () -> luhnybin.luhny

		'should correctly identify strings that pass the Luhny test': (luhny) ->
			assert.isTrue luhny toArray('5678')

		'should not have false positives': (luhny) ->
			assert.isFalse luhny toArray('6789')

		'should accurately identify a potentially valid credit card number': (luhny) ->
			assert.isTrue luhny toArray(valid.pureDigits['14'].number)
	
	'The hideFrom function':
		topic: () -> luhnybin.hideFrom

		'should work on arrays made up entirely of digits': (hideFrom) ->
			assert.deepEqual hideFrom(['1', '2', '3'], 0, 3), ['X', 'X', 'X']

		'should work on arrays with non-digits': (hideFrom) ->
			assert.deepEqual hideFrom(['a', '4', '5', 'c', 'd', '2'], 0, 3), ['a', 'X', 'X', 'c', 'd', 'X']

		'should ignore digits before the range specified': (hideFrom) ->
			assert.deepEqual hideFrom(['1', '2', '3', 'a', '4'], 1, 3), ['1', 'X', 'X', 'a', 'X']

		'should ignore digits after the range specified': (hideFrom) ->
			assert.deepEqual hideFrom(['1', '2', 'z', '9', '2'], 0, 3), ['X', 'X', 'z', 'X', '2']

	
	'The mask function':
		topic: () -> luhnybin.mask

		'should mask an exact credit card number with no spaces': (mask) ->
			testCard = valid.pureDigits['14']
			assert.deepEqual mask(toArray(testCard.number)), toArray(testCard.mask)

		'should mask an exact credit card number with dashes': (mask) ->
			testCard = valid.dashes['14']
			assert.deepEqual mask(toArray(testCard.number)), toArray(testCard.mask)

		'should mask an exact credit card number with spaces': (mask) ->
			testCard = valid.spaces['14']
			assert.deepEqual mask(toArray(testCard.number)), toArray(testCard.mask)

		'should mask a credit card number with extra invalid digits before it': (mask) ->
			testCard = valid.spaces['14']
			assert.deepEqual mask(toArray('1' + testCard.number)), toArray('1' + testCard.mask)

		'should mask a credit card number with extra invalid digits after it': (mask) ->
			testCard = valid.dashes['14']
			assert.deepEqual mask(toArray(testCard.number + '1')), toArray(testCard.mask + '1')

		'should mask two valid credit card numbers in a row': (mask) ->
			testCard = valid.pureDigits['14']
			assert.deepEqual mask(toArray(testCard.number + testCard.number)), toArray(testCard.mask + testCard.mask)
	
	'The hideCreditCards function':
		topic: () -> luhnybin.hideCreditCards

		'should hide a valid credit card': (hideCreditCards) ->
			testCard = valid.pureDigits['14']
			assert.equal hideCreditCards(testCard.number), testCard.mask

		'should hide two valid credit cards in a row': (hideCreditCards) ->
			testCard = valid.pureDigits['14']
			assert.equal hideCreditCards(testCard.number + testCard.number), testCard.mask + testCard.mask

		'should not hide invalid cards': (hideCreditCards) ->
			testCard = invalid.pureDigits['14']
			assert.equal hideCreditCards(testCard.number), testCard.mask


suite.export module
