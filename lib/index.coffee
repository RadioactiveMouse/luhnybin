MIN_CREDIT_LENGTH = 14
MAX_CREDIT_LENGTH = 16
MASK_CHAR = 'X'

SMALLEST_DIGIT_CODE = '0'.charCodeAt(0)
LARGEST_DIGIT_CODE = '9'.charCodeAt(0)
DOUBLED_AND_SUMMED = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]

###
 luhny
 -----
 takes an array of digits.
 returns true if the digits pass the Luhn check, false otherwise.
###

luhny = (digits) ->
	sum = 0
	odd = false

	for index in [digits.length - 1 .. 0]
		digit = digits[index]
		sum += if odd then DOUBLED_AND_SUMMED[digit] else digit
		odd = !odd
	
	sum % 10 == 0

###
 mask
 ----
 takes an array of single-character strings composed of digits, dashes, and spaces.
 returns a clone of the array, except that any potentially valid credit card numbers are masked with Xs.
###

mask = (creditArray) ->
	creditArray = creditArray.slice 0
	indices = []
	digits = []
	for index in [0...creditArray.length]
		code = creditArray[index].charCodeAt(0)
		if code >= SMALLEST_DIGIT_CODE && code <= LARGEST_DIGIT_CODE
			digits.push code - SMALLEST_DIGIT_CODE
			indices.push index
	
	return creditArray if digits.length < MIN_CREDIT_LENGTH
	
	for nthDigit in [0..digits.length - MIN_CREDIT_LENGTH]
		for offset in [nthDigit + MAX_CREDIT_LENGTH .. nthDigit + MIN_CREDIT_LENGTH]
			if digits.length >= offset
				subdigits = digits.slice nthDigit, offset
				if luhny subdigits
					for i in [nthDigit...offset]
						creditArray[indices[i]] = MASK_CHAR
					break
	
	creditArray

###
 hideCreditCards
 ---------------
 takes a string.
 returns a clone of the string, except that any potentially valid credit card numbers are hidden.
###

hideCreditCards = (input) ->
	output = []
	potentialCardStack = []
	potentialRegex = /[\d\-\s]/
	pumpCardStack = () ->
		output = output.concat mask potentialCardStack
		potentialCardStack = []

	for nthChar in [0...input.length]
		currChar = input.charAt nthChar
		if potentialRegex.test currChar
			potentialCardStack.push currChar
		else
			pumpCardStack() if potentialCardStack.length > 0
			output.push currChar
	
	pumpCardStack() if potentialCardStack.length > 0
	output.join ''


###
 export everything
###

exports.luhny = luhny
exports.mask = mask
exports.hideCreditCards = hideCreditCards
