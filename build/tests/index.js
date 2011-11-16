var assert, invalid, luhnybin, suite, toArray, valid, vows;

vows = require('vows');

assert = require('assert');

luhnybin = require('../lib');

valid = {
  pureDigits: {
    '14': {
      number: '56613959932537',
      mask: 'XXXXXXXXXXXXXX'
    }
  },
  dashes: {
    '14': {
      number: '5-66139-59932-537',
      mask: 'X-XXXXX-XXXXX-XXX'
    }
  },
  spaces: {
    '14': {
      number: '566 13959 9325 37',
      mask: 'XXX XXXXX XXXX XX'
    }
  }
};

invalid = {
  pureDigits: {
    '14': {
      number: '49536290423965',
      mask: '49536290423965'
    }
  }
};

toArray = function(string) {
  var index, _ref, _results;
  _results = [];
  for (index = 0, _ref = string.length; 0 <= _ref ? index < _ref : index > _ref; 0 <= _ref ? index++ : index--) {
    _results.push(string.charAt(index));
  }
  return _results;
};

suite = vows.describe('Luhny Masking').addBatch({
  'The Luhny test function': {
    topic: function() {
      return luhnybin.luhny;
    },
    'should correctly identify strings that pass the Luhny test': function(luhny) {
      return assert.isTrue(luhny([5, 6, 7, 8]));
    },
    'should not have false positives': function(luhny) {
      return assert.isFalse(luhny([6, 7, 8, 9]));
    }
  },
  'The mask function': {
    topic: function() {
      return luhnybin.mask;
    },
    'should mask an exact credit card number with no spaces': function(mask) {
      var testCard;
      testCard = valid.pureDigits['14'];
      return assert.deepEqual(mask(toArray(testCard.number)), toArray(testCard.mask));
    },
    'should mask an exact credit card number with dashes': function(mask) {
      var testCard;
      testCard = valid.dashes['14'];
      return assert.deepEqual(mask(toArray(testCard.number)), toArray(testCard.mask));
    },
    'should mask an exact credit card number with spaces': function(mask) {
      var testCard;
      testCard = valid.spaces['14'];
      return assert.deepEqual(mask(toArray(testCard.number)), toArray(testCard.mask));
    },
    'should mask a credit card number with extra invalid digits before it': function(mask) {
      var testCard;
      testCard = valid.spaces['14'];
      return assert.deepEqual(mask(toArray('1' + testCard.number)), toArray('1' + testCard.mask));
    },
    'should mask a credit card number with extra invalid digits after it': function(mask) {
      var testCard;
      testCard = valid.dashes['14'];
      return assert.deepEqual(mask(toArray(testCard.number + '1')), toArray(testCard.mask + '1'));
    },
    'should mask two valid credit card numbers in a row': function(mask) {
      var testCard;
      testCard = valid.pureDigits['14'];
      return assert.deepEqual(mask(toArray(testCard.number + testCard.number)), toArray(testCard.mask + testCard.mask));
    }
  },
  'The hideCreditCards function': {
    topic: function() {
      return luhnybin.hideCreditCards;
    },
    'should hide a valid credit card': function(hideCreditCards) {
      var testCard;
      testCard = valid.pureDigits['14'];
      return assert.equal(hideCreditCards(testCard.number), testCard.mask);
    },
    'should hide two valid credit cards in a row': function(hideCreditCards) {
      var testCard;
      testCard = valid.pureDigits['14'];
      return assert.equal(hideCreditCards(testCard.number + testCard.number), testCard.mask + testCard.mask);
    },
    'should not hide invalid cards': function(hideCreditCards) {
      var testCard;
      testCard = invalid.pureDigits['14'];
      return assert.equal(hideCreditCards(testCard.number), testCard.mask);
    }
  }
});

suite["export"](module);
