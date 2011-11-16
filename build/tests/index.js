var assert, invalid, luhnybin, suite, valid, vows;

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

suite = vows.describe('Luhny Masking').addBatch({
  'The Luhny test function': {
    topic: function() {
      return luhnybin.luhny;
    },
    'should correctly identify strings that pass the Luhny test': function(luhny) {
      return assert.isTrue(luhny('5678'));
    },
    'should not have false positives': function(luhny) {
      return assert.isFalse(luhny('6789'));
    },
    'should accurately identify a potentially valid credit card number': function(luhny) {
      return assert.isTrue(luhny(valid.pureDigits['14'].number));
    }
  },
  'The hideFrom function': {
    topic: function() {
      return luhnybin.hideFrom;
    },
    'should work on strings made up entirely of digits': function(hideFrom) {
      return assert.equal(hideFrom('123', 0, 3), 'XXX');
    },
    'should work on strings with non-digits': function(hideFrom) {
      return assert.equal(hideFrom('a45cd2', 0, 3), 'aXXcdX');
    },
    'should ignore digits before the range specified': function(hideFrom) {
      return assert.equal(hideFrom('123a4', 1, 3), '1XXaX');
    },
    'should ignore digits after the range specified': function(hideFrom) {
      return assert.equal(hideFrom('12z92', 0, 3), 'XXzX2');
    }
  },
  'The mask function': {
    topic: function() {
      return luhnybin.mask;
    },
    'should mask an exact credit card number with no spaces': function(mask) {
      var testCard;
      testCard = valid.pureDigits['14'];
      return assert.equal(mask(testCard.number), testCard.mask);
    },
    'should mask an exact credit card number with dashes': function(mask) {
      var testCard;
      testCard = valid.dashes['14'];
      return assert.equal(mask(testCard.number), testCard.mask);
    },
    'should mask an exact credit card number with spaces': function(mask) {
      var testCard;
      testCard = valid.spaces['14'];
      return assert.equal(mask(testCard.number), testCard.mask);
    },
    'should mask a credit card number with extra invalid digits before it': function(mask) {
      var testCard;
      testCard = valid.spaces['14'];
      return assert.equal(mask('1' + testCard.number), '1' + testCard.mask);
    },
    'should mask a credit card number with extra invalid digits after it': function(mask) {
      var testCard;
      testCard = valid.dashes['14'];
      return assert.equal(mask(testCard.number + '1'), testCard.mask + '1');
    },
    'should mask two valid credit card numbers in a row': function(mask) {
      var testCard;
      testCard = valid.pureDigits['14'];
      return assert.equal(mask(testCard.number + testCard.number), testCard.mask + testCard.mask);
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
