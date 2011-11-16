var LARGEST_DIGIT_CODE, MAX_CREDIT_LENGTH, MIN_CREDIT_LENGTH, SMALLEST_DIGIT_CODE, hideCreditCards, hideFrom, luhny, mask;

MIN_CREDIT_LENGTH = 14;

MAX_CREDIT_LENGTH = 16;

SMALLEST_DIGIT_CODE = '0'.charCodeAt(0);

LARGEST_DIGIT_CODE = '9'.charCodeAt(0);

/*
 luhny
 -----
 takes an array of single-character strings of digits.
 returns true if the string passes the Luhn check, false otherwise.
*/

luhny = function(digits) {
  var digit, index, odd, sum, _ref;
  sum = 0;
  odd = false;
  for (index = _ref = digits.length - 1; _ref <= 0 ? index <= 0 : index >= 0; _ref <= 0 ? index++ : index--) {
    digit = digits[index].charCodeAt(0) - SMALLEST_DIGIT_CODE;
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
 takes an array, the nth digit to start hiding, and the number of digits to hide.
 return a clone of the array, except that `num` digits from the `nthDigit` are overwritten with Xs.
*/

hideFrom = function(array, nthDigit, num) {
  var clone, code, index, n, _ref;
  n = 0;
  clone = array.slice(0);
  for (index = 0, _ref = array.length; 0 <= _ref ? index < _ref : index > _ref; 0 <= _ref ? index++ : index--) {
    if (n >= nthDigit + num) return clone;
    code = array[index].charCodeAt(0);
    if (code >= SMALLEST_DIGIT_CODE && code <= LARGEST_DIGIT_CODE) {
      if (n >= nthDigit) clone[index] = 'X';
      n++;
    }
  }
  return clone;
};

/*
 mask
 ----
 takes an array of strings composed of digits, dashes, and spaces.
 returns the a clone of the array, except that any potentially valid credit card numbers are masked with Xs.
*/

mask = function(creditArray) {
  var alreadyHidden, amountToHide, delta, digits, nMoreHidden, nthDigit, startingPoint, subdigits, _ref, _ref2;
  creditArray = creditArray.slice(0);
  digits = creditArray.filter(function(character) {
    return /\d/.test(character);
  });
  if (digits.length < MIN_CREDIT_LENGTH) return creditArray;
  subdigits = [];
  alreadyHidden = 0;
  nMoreHidden = 0;
  for (nthDigit = 0, _ref = digits.length - MIN_CREDIT_LENGTH; 0 <= _ref ? nthDigit <= _ref : nthDigit >= _ref; 0 <= _ref ? nthDigit++ : nthDigit--) {
    for (delta = _ref2 = MAX_CREDIT_LENGTH - MIN_CREDIT_LENGTH; _ref2 <= 0 ? delta <= 0 : delta >= 0; _ref2 <= 0 ? delta++ : delta--) {
      if (digits.length - nthDigit >= MIN_CREDIT_LENGTH + delta) {
        subdigits = digits.slice(nthDigit, nthDigit + MIN_CREDIT_LENGTH + delta);
        if (luhny(subdigits)) {
          amountToHide = subdigits.length - nMoreHidden;
          startingPoint = nthDigit - alreadyHidden + nMoreHidden;
          creditArray = hideFrom(creditArray, startingPoint, amountToHide);
          alreadyHidden += amountToHide;
          nMoreHidden += amountToHide;
          break;
        }
      }
    }
    if (nMoreHidden > 0) nMoreHidden--;
  }
  return creditArray;
};

/*
 hideCreditCards
 ---------------
 takes a string.
 returns a clone of the string, except that any potentially valid credit card numbers are hidden.
*/

hideCreditCards = function(input) {
  var currChar, nthChar, output, potentialCardStack, potentialRegex, pumpCardStack, _ref;
  output = [];
  potentialCardStack = [];
  potentialRegex = /[\d\-\s]/;
  pumpCardStack = function() {
    output = output.concat(mask(potentialCardStack));
    return potentialCardStack = [];
  };
  for (nthChar = 0, _ref = input.length; 0 <= _ref ? nthChar < _ref : nthChar > _ref; 0 <= _ref ? nthChar++ : nthChar--) {
    currChar = input.charAt(nthChar);
    if (potentialRegex.test(currChar)) {
      potentialCardStack.push(currChar);
    } else {
      if (potentialCardStack.length > 0) pumpCardStack();
      output.push(currChar);
    }
  }
  if (potentialCardStack.length > 0) pumpCardStack();
  return output.join('');
};

/*
 export everything
*/

exports.luhny = luhny;

exports.hideFrom = hideFrom;

exports.mask = mask;

exports.hideCreditCards = hideCreditCards;
