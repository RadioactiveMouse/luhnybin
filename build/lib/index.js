var LARGEST_DIGIT_CODE, MAX_CREDIT_LENGTH, MIN_CREDIT_LENGTH, SMALLEST_DIGIT_CODE, hideCreditCards, hideFrom, luhny, mask;

MIN_CREDIT_LENGTH = 14;

MAX_CREDIT_LENGTH = 16;

SMALLEST_DIGIT_CODE = '0'.charCodeAt(0);

LARGEST_DIGIT_CODE = '9'.charCodeAt(0);

/*
 luhny
 -----
 takes a string composed entirely of digits.
 returns true if the string passes the Luhn check, false otherwise.
*/

luhny = function(digitString) {
  var digit, index, odd, sum, _ref;
  sum = 0;
  odd = false;
  for (index = _ref = digitString.length - 1; _ref <= 0 ? index <= 0 : index >= 0; _ref <= 0 ? index++ : index--) {
    digit = digitString.charCodeAt(index) - SMALLEST_DIGIT_CODE;
    if (odd) {
      digit *= 2;
      if (digit >= 10) {
        sum += Math.floor(digit / 10);
        digit = digit % 10;
      }
    }
    sum += digit;
    odd = !odd;
  }
  return sum % 10 === 0;
};

/*
 hideFrom
 --------
 takes a string, the nth digit to start hiding, and the number of digits to hide.

 returns the same string, except that `num` digits from the `nthDigit` are overwritten with Xs.
*/

hideFrom = function(string, nthDigit, num) {
  var currChar, currCharCode, index, n, output, _ref;
  output = '';
  n = 0;
  for (index = 0, _ref = string.length; 0 <= _ref ? index < _ref : index > _ref; 0 <= _ref ? index++ : index--) {
    currChar = string.charAt(index);
    currCharCode = string.charCodeAt(index);
    if (currCharCode <= LARGEST_DIGIT_CODE && currCharCode >= SMALLEST_DIGIT_CODE && n < nthDigit + num) {
      if (n >= nthDigit) currChar = 'X';
      n++;
    }
    output += currChar;
  }
  return output;
};

/*
 mask
 ----
 takes a string composed of digits, dashes, and spaces.
 returns the same string, except that any potentially valid credit card numbers are masked with Xs.
*/

mask = function(creditString) {
  var alreadyHidden, amountToHide, delta, digits, nMoreHidden, nthDigit, startingPoint, subdigits, _ref, _ref2;
  digits = creditString.replace(/\-/g, '').replace(/\s/g, '');
  if (digits.length < MIN_CREDIT_LENGTH) return creditString;
  subdigits = '';
  alreadyHidden = 0;
  nMoreHidden = 0;
  for (nthDigit = 0, _ref = digits.length - MIN_CREDIT_LENGTH; 0 <= _ref ? nthDigit <= _ref : nthDigit >= _ref; 0 <= _ref ? nthDigit++ : nthDigit--) {
    for (delta = _ref2 = MAX_CREDIT_LENGTH - MIN_CREDIT_LENGTH; _ref2 <= 0 ? delta <= 0 : delta >= 0; _ref2 <= 0 ? delta++ : delta--) {
      if (digits.length - nthDigit >= MIN_CREDIT_LENGTH + delta) {
        subdigits = digits.substr(nthDigit, MIN_CREDIT_LENGTH + delta);
        if (luhny(subdigits)) {
          amountToHide = subdigits.length - nMoreHidden;
          startingPoint = nthDigit - alreadyHidden + nMoreHidden;
          creditString = hideFrom(creditString, startingPoint, amountToHide);
          alreadyHidden += amountToHide;
          nMoreHidden += amountToHide;
          break;
        }
      }
    }
    if (nMoreHidden > 0) nMoreHidden--;
  }
  return creditString;
};

/*
 hideCreditCards
 ---------------
 takes a string.
 returns the same string, except that any potentially valid credit card numbers are hidden.
*/

hideCreditCards = function(input) {
  var currChar, nthChar, output, potentialCardStack, potentialRegex, pumpCardStack, _ref;
  output = '';
  potentialCardStack = '';
  potentialRegex = /[\d\-\s]/;
  pumpCardStack = function() {
    output += mask(potentialCardStack);
    return potentialCardStack = '';
  };
  for (nthChar = 0, _ref = input.length; 0 <= _ref ? nthChar < _ref : nthChar > _ref; 0 <= _ref ? nthChar++ : nthChar--) {
    currChar = input.charAt(nthChar);
    if (potentialRegex.test(currChar)) {
      potentialCardStack += currChar;
    } else {
      if (potentialCardStack.length > 0) pumpCardStack();
      output += currChar;
    }
  }
  if (potentialCardStack.length > 0) pumpCardStack();
  return output;
};

/*
 export everything
*/

exports.luhny = luhny;

exports.hideFrom = hideFrom;

exports.mask = mask;

exports.hideCreditCards = hideCreditCards;
