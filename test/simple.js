
var FIXTURES_DIR;

FIXTURES_DIR = __dirname + "/fixtures";

describe('simple', function() {
  it('should fit element to browser on load', function(done) {
    var fs = require('fs');
    
    fs.readFile(FIXTURES_DIR + "/simple_01.html", function(err, result) {
      return console.log(arguments);
    });
    return done(null);
  });
  return it('should fit element on resize', function() {});
});