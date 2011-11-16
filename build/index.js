var hideCreditCards;

hideCreditCards = require('./lib').hideCreditCards;

process.stdin.resume();

process.stdin.setEncoding('ascii');

process.stdin.on('data', function(data) {
  var test, tests, _i, _len;
  tests = data.split('\n');
  for (_i = 0, _len = tests.length; _i < _len; _i++) {
    test = tests[_i];
    console.log(hideCreditCards(test));
  }
});
