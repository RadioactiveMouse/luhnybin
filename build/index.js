var hideCreditCards, input;

hideCreditCards = require('./lib').hideCreditCards;

input = '';

process.stdin.resume();

process.stdin.setEncoding('ascii');

process.stdin.on('data', function(data) {
  var lastTest, test, tests, _i, _len;
  input += data;
  tests = input.split('\n');
  lastTest = tests[tests.length - 1];
  if (lastTest.charAt(lastTest.length - 1) === '\n') {
    input = '';
  } else {
    input = tests.pop();
  }
  for (_i = 0, _len = tests.length; _i < _len; _i++) {
    test = tests[_i];
    console.log(hideCreditCards(test));
  }
});
