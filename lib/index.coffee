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
 takes an array, the nth digit to start hiding, and the number of digits to hide.
 return a clone of the array, except that `num` digits from the `nthDigit` are overwritten with Xs.
###

hideFrom = (array, nthDigit, num) ->
	n = 0
	clone = array.slice 0
	for index in [0...array.length]
		if n >= nthDigit + num
			return clone

		code = array[index].charCodeAt(0)
		if code >= SMALLEST_DIGIT_CODE && code <= LARGEST_DIGIT_CODE
			clone[index] = 'X' if n >= nthDigit
			n++

	clone

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
	alreadyHidden = 0
	nMoreHidden = 0

	for nthDigit in [0..digits.length - MIN_CREDIT_LENGTH]
		for delta in [MAX_CREDIT_LENGTH - MIN_CREDIT_LENGTH .. 0]
			if digits.length - nthDigit >= MIN_CREDIT_LENGTH + delta
				subdigits = digits.slice nthDigit, nthDigit + MIN_CREDIT_LENGTH + delta
				if luhny subdigits
					amountToHide = subdigits.length - nMoreHidden
					startingPoint = nthDigit - alreadyHidden + nMoreHidden
					creditArray = hideFrom creditArray, startingPoint, amountToHide
					alreadyHidden += amountToHide
					nMoreHidden += amountToHide
					break
		nMoreHidden-- if nMoreHidden > 0
	
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
exports.hideFrom = hideFrom
exports.mask = mask
exports.hideCreditCards = hideCreditCards
