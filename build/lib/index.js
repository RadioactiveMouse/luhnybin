var DOUBLED_AND_SUMMED, LARGEST_DIGIT_CODE, MASK_CHAR, MAX_CREDIT_LENGTH, MIN_CREDIT_LENGTH, SMALLEST_DIGIT_CODE, hideCreditCards, luhny, mask;

MIN_CREDIT_LENGTH = 14;

MAX_CREDIT_LENGTH = 16;

MASK_CHAR = 'X';

SMALLEST_DIGIT_CODE = '0'.charCodeAt(0);

LARGEST_DIGIT_CODE = '9'.charCodeAt(0);

DOUBLED_AND_SUMMED = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];

/*
 luhny
 -----
 takes an array of digits.
 returns true if the digits pass the Luhn check, false otherwise.
*/

luhny = function(digits) {
  var digit, index, odd, sum, _ref;
  sum = 0;
  odd = false;
  for (index = _ref = digits.length - 1; _ref <= 0 ? index <= 0 : index >= 0; _ref <= 0 ? index++ : index--) {
    digit = digits[index];
    sum += odd ? DOUBLED_AND_SUMMED[digit] : digit;
    odd = !odd;
  }
  return sum % 10 === 0;
};

/*
 mask
 ----
 takes an array of single-character strings composed of digits, dashes, and spaces.
 returns a clone of the array, except that any potentially valid credit card numbers are masked with Xs.
*/

mask = function(creditArray) {
  var code, delta, digits, i, index, indices, nthDigit, subdigits, _ref, _ref2, _ref3, _ref4;
  creditArray = creditArray.slice(0);
  indices = [];
  digits = [];
  for (index = 0, _ref = creditArray.length; 0 <= _ref ? index < _ref : index > _ref; 0 <= _ref ? index++ : index--) {
    code = creditArray[index].charCodeAt(0);
    if (code >= SMALLEST_DIGIT_CODE && code <= LARGEST_DIGIT_CODE) {
      digits.push(code - SMALLEST_DIGIT_CODE);
      indices.push(index);
    }
  }
  if (digits.length < MIN_CREDIT_LENGTH) return creditArray;
  for (nthDigit = 0, _ref2 = digits.length - MIN_CREDIT_LENGTH; 0 <= _ref2 ? nthDigit <= _ref2 : nthDigit >= _ref2; 0 <= _ref2 ? nthDigit++ : nthDigit--) {
    for (delta = _ref3 = MAX_CREDIT_LENGTH - MIN_CREDIT_LENGTH; _ref3 <= 0 ? delta <= 0 : delta >= 0; _ref3 <= 0 ? delta++ : delta--) {
      if (digits.length - nthDigit >= MIN_CREDIT_LENGTH + delta) {
        subdigits = digits.slice(nthDigit, nthDigit + MIN_CREDIT_LENGTH + delta);
        if (luhny(subdigits)) {
          for (i = nthDigit, _ref4 = nthDigit + subdigits.length; nthDigit <= _ref4 ? i < _ref4 : i > _ref4; nthDigit <= _ref4 ? i++ : i--) {
            creditArray[indices[i]] = MASK_CHAR;
          }
          break;
        }
      }
    }
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

exports.mask = mask;

exports.hideCreditCards = hideCreditCards;
