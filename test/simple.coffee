chai = require 'chai'
raf = require 'raf'
fs = require 'fs'
maximus = require '../index.coffee'

chai.should()

describe 'simple', ->
  beforeEach ->
    maximus.reset()
    
  it 'should fit element to browser on load', (done) ->
    fs.readFile "#{__dirname}/fixtures/simple_01.html", (err, result) ->
      div = document.createElement('div')
      div.innerHTML = result.toString()
      document.querySelector('body').appendChild(div.firstChild)
      
      element = document.querySelector('body div:last-of-type')
      maximus(element)
      
      element.getBoundingClientRect().left.should.equal(0)
      element.offsetWidth.should.equal(document.documentElement.clientWidth)
    
      done()
  
  it 'should fit element on resize', (done) ->
    fs.readFile "#{__dirname}/fixtures/simple_01.html", (err, result) ->
      div = document.createElement('div')
      div.innerHTML = result.toString()
      document.querySelector('body').appendChild(div.firstChild)
      
      element = document.querySelector('body div:last-of-type')
      
      maximus(element)
      
      element.parentNode.style.marginLeft = '20px'
      element.parentNode.parentNode.style.marginLeft = '20px'
      element.parentNode.parentNode.style.marginRight = '20px'
    
      event = document.createEvent('Event')
      event.initEvent('resize', false, false)
      top.window.dispatchEvent(event)
    
      raf ->
        element.getBoundingClientRect().left.should.equal(0)
        element.offsetWidth.should.equal(document.documentElement.clientWidth)
        done()