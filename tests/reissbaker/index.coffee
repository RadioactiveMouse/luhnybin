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

suite = vows.describe('Luhny Masking').addBatch
	'The Luhny test function':
		topic: () -> luhnybin.luhny

		'should correctly identify strings that pass the Luhny test': (luhny) ->
			assert.isTrue luhny '5678'

		'should not have false positives': (luhny) ->
			assert.isFalse luhny '6789'

		'should accurately identify a potentially valid credit card number': (luhny) ->
			assert.isTrue luhny valid.pureDigits['14'].number
	
	'The hideFrom function':
		topic: () -> luhnybin.hideFrom

		'should work on strings made up entirely of digits': (hideFrom) ->
			assert.equal hideFrom('123', 0, 3), 'XXX'

		'should work on strings with non-digits': (hideFrom) ->
			assert.equal hideFrom('a45cd2', 0, 3), 'aXXcdX'

		'should ignore digits before the range specified': (hideFrom) ->
			assert.equal hideFrom('123a4', 1, 3), '1XXaX'

		'should ignore digits after the range specified': (hideFrom) ->
			assert.equal hideFrom('12z92', 0, 3), 'XXzX2'
	
	'The mask function':
		topic: () -> luhnybin.mask

		'should mask an exact credit card number with no spaces': (mask) ->
			testCard = valid.pureDigits['14']
			assert.equal mask(testCard.number), testCard.mask

		'should mask an exact credit card number with dashes': (mask) ->
			testCard = valid.dashes['14']
			assert.equal mask(testCard.number), testCard.mask

		'should mask an exact credit card number with spaces': (mask) ->
			testCard = valid.spaces['14']
			assert.equal mask(testCard.number), testCard.mask

		'should mask a credit card number with extra invalid digits before it': (mask) ->
			testCard = valid.spaces['14']
			assert.equal mask('1' + testCard.number), '1' + testCard.mask

		'should mask a credit card number with extra invalid digits after it': (mask) ->
			testCard = valid.dashes['14']
			assert.equal mask(testCard.number + '1'), testCard.mask + '1'

		'should mask two valid credit card numbers in a row': (mask) ->
			testCard = valid.pureDigits['14']
			assert.equal mask(testCard.number + testCard.number), testCard.mask + testCard.mask
	
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
