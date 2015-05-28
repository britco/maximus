chai = require 'chai'
raf = require 'raf'
fs = require 'fs'
maximus = require '../index.coffee'

chai.should()

describe 'simple', ->
  beforeEach ->
    # Reset event listeners and such
    maximus.reset()
    
    # Remove test divs
    Array.prototype.forEach.call document.querySelectorAll('[test-div]'), (elem) ->
      elem.parentNode.removeChild(elem)
  
  it 'should fit element to browser on load', (done) ->
    fs.readFile "#{__dirname}/fixtures/simple_01.html", (err, result) ->
      div = document.createElement('div')
      div.innerHTML = result.toString()
      
      div.firstChild.setAttribute('test-div','')
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
      
      div.firstChild.setAttribute('test-div','')
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
  
  it 'should support selector syntax', (done) ->
    fs.readFile "#{__dirname}/fixtures/simple_01.html", (err, result) ->
      div = document.createElement('div')
      div.innerHTML = result.toString()
      div.firstChild.setAttribute('test-div','')
      document.querySelector('body').appendChild(div.firstChild)
      
      selector = '.simple-01-inner'
      
      maximus(selector)
      
      element = document.querySelector(selector)
      
      element.getBoundingClientRect().left.should.equal(0)
      element.offsetWidth.should.equal(document.documentElement.clientWidth)
          
      done()
  
  it 'should not have to do anything if element is already maximized', (done) ->
    document.querySelector('body').style.margin = 0
    
    fs.readFile "#{__dirname}/fixtures/simple_02.html", (err, result) ->
      div = document.createElement('div')
      div.innerHTML = result.toString()
      div.firstChild.setAttribute('test-div','')
      document.querySelector('body').appendChild(div.firstChild)
      
      element = document.querySelector('.simple-02-inner:last-of-type')
      
      maximus(element)
      
      document.querySelector('body').removeAttribute('style')
      
      done()
    