module.exports = 
  getFixtureFragment: (filename, done) ->
    # `var fs = require('fs')`
    fs = require 'fs'
    
    root = 'test/fixtures'
    # console.log "#{root}/#{filename}"
    # console.log 'fs',fs
    
    # fs.readFile "test/fixtures/simple_01.html", (err, result) ->
    #   console.log result
      # fragment = document.createFragment()
      # fragment.innerHTML = result.toString()
      # done(null, fragment)
    
    