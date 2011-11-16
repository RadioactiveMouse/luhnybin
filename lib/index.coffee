MIN_CREDIT_LENGTH = 14
MAX_CREDIT_LENGTH = 16
SMALLEST_DIGIT_CODE = '0'.charCodeAt(0)
LARGEST_DIGIT_CODE = '9'.charCodeAt(0)

###
 luhny
 -----
 takes an array of single-character strings of digits.
 returns true if the string passes the Luhn check, false otherwise.
###

luhny = (digits) ->
	sum = 0
	odd = false

	for index in [digits.length - 1 .. 0]
		digit = digits[index].charCodeAt(0) - SMALLEST_DIGIT_CODE
		if odd
			digit *= 2
			if digit >= 10
				sum += Math.floor digit / 10
				digit = digit % 10
		sum += digit
		odd = !odd
	
	sum % 10 == 0

###
 hideFrom
 --------
 takes an array of single-character strings, and an ordered array of pairs of the form [nthDigit, num].

 return a clone of the array, except that `num` digits from the `nthDigit` are overwritten with Xs for 
 each pair.
###

hideFrom = (array, pairs) ->
	n = 0
	array = array.slice 0
	return array if pairs.length == 0

	currPairIndex = 0
	nthDigit = pairs[currPairIndex][0]
	num = pairs[currPairIndex][1]

	for index in [0...array.length]
		code = array[index].charCodeAt(0)
		if code >= SMALLEST_DIGIT_CODE && code <= LARGEST_DIGIT_CODE
			array[index] = 'X' if n >= nthDigit
			n++

		while n >= nthDigit + num
			currPairIndex++
			return array if currPairIndex >= pairs.length
			nthDigit = pairs[currPairIndex][0]
			num = pairs[currPairIndex][1]

	array

###
 mask
 ----
 takes an array of single-character strings composed of digits, dashes, and spaces.
 returns a clone of the array, except that any potentially valid credit card numbers are masked with Xs.
###

mask = (creditArray) ->
	creditArray = creditArray.slice 0
	digits = creditArray.filter (character) ->
		/\d/.test character
	
	return creditArray if digits.length < MIN_CREDIT_LENGTH
	
	subdigits = []
	pairs = []
	alreadyHidden = 0
	nMoreHidden = 0

	for nthDigit in [0..digits.length - MIN_CREDIT_LENGTH]
		for delta in [MAX_CREDIT_LENGTH - MIN_CREDIT_LENGTH .. 0]
			if digits.length - nthDigit >= MIN_CREDIT_LENGTH + delta
				subdigits = digits.slice nthDigit, nthDigit + MIN_CREDIT_LENGTH + delta
				if luhny subdigits
					amountToHide = subdigits.length
					do (nthDigit, amountToHide) ->
						pairs.push [nthDigit, amountToHide]
						return
					alreadyHidden += amountToHide
					nMoreHidden += amountToHide
					break
		nMoreHidden-- if nMoreHidden > 0
	
	hideFrom creditArray, pairs

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
exports.hideFrom = hideFrom
exports.mask = mask
exports.hideCreditCards = hideCreditCards
