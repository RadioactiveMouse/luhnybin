MIN_CREDIT_LENGTH = 14
MAX_CREDIT_LENGTH = 16
SMALLEST_DIGIT_CODE = '0'.charCodeAt(0)
LARGEST_DIGIT_CODE = '9'.charCodeAt(0)

###
 luhny
 -----
 takes a string composed entirely of digits.
 returns true if the string passes the Luhn check, false otherwise.
###

luhny = (digitString) ->
	sum = 0

	for index in [digitString.length - 1 .. 0]
		digit = digitString.charCodeAt(index) - SMALLEST_DIGIT_CODE
		if (digitString.length - 1 - index) % 2 != 0
			digit *= 2
			if digit >= 10
				sum += Math.floor digit / 10
				digit = digit % 10
		sum += digit
	
	sum % 10 == 0


###
 hideFrom
 --------
 takes a string, the nth digit to start hiding, and the number of digits to hide.

 returns the same string, except that `num` digits from the `nthDigit` are overwritten with Xs.
###

hideFrom = (string, nthDigit, num) ->
	output = ''
	n = 0

	for index in [0...string.length]
		currChar = string.charAt index
		currCharCode = string.charCodeAt index
		if n < nthDigit + num && currCharCode <= LARGEST_DIGIT_CODE && currCharCode >= SMALLEST_DIGIT_CODE
			currChar = 'X' if n >= nthDigit
			n++
		output += currChar

	output


###
 mask
 ----
 takes a string composed of digits, dashes, and spaces.
 returns the same string, except that any potentially valid credit card numbers are masked with Xs.
###

mask = (creditString) ->
	digits = creditString.replace(/\-/g, '').replace(/\s/g, '')
	if digits.length < MIN_CREDIT_LENGTH
		return creditString
	
	subdigits = ''
	alreadyHidden = 0
	nMoreHidden = 0

	for nthDigit in [0..digits.length - MIN_CREDIT_LENGTH]
		for delta in [MAX_CREDIT_LENGTH - MIN_CREDIT_LENGTH .. 0]
			if digits.length - nthDigit >= MIN_CREDIT_LENGTH + delta
				subdigits = digits.substr nthDigit, MIN_CREDIT_LENGTH + delta
				if luhny subdigits
					amountToHide = subdigits.length - nMoreHidden
					startingPoint = nthDigit - alreadyHidden + nMoreHidden
					creditString = hideFrom creditString, startingPoint, amountToHide
					alreadyHidden += amountToHide
					nMoreHidden += amountToHide
					break
		nMoreHidden-- if nMoreHidden > 0
	
	creditString

###
 hideCreditCards
 ---------------
 takes a string.
 returns the same string, except that any potentially valid credit card numbers are hidden.
###

hideCreditCards = (input) ->
	output = ''
	potentialCardStack = ''
	potentialRegex = /[\d\-\s]/
	pumpCardStack = () ->
		output += mask potentialCardStack
		potentialCardStack = ''

	for nthChar in [0...input.length]
		currChar = input.charAt nthChar
		if potentialRegex.test currChar
			potentialCardStack += currChar
		else
			pumpCardStack() if potentialCardStack.length > 0
			output += currChar
	
	pumpCardStack() if potentialCardStack.length > 0
	output


###
 export everything
###

exports.luhny = luhny
exports.hideFrom = hideFrom
exports.mask = mask
exports.hideCreditCards = hideCreditCards
