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
			assert.isTrue luhny [5, 6, 7, 8]

		'should not have false positives': (luhny) ->
			assert.isFalse luhny [6, 7, 8, 9]

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
