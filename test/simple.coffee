chai = require 'chai'
maximus = require '../index.coffee'
documentHelpers = require './helpers/document'

FIXTURES_DIR = "#{__dirname}/fixtures"

chai.should()

describe 'simple', ->
  beforeEach ->
    maximus.reset()
    
  it 'should fit element to browser on load', (done) ->
    fs = require 'fs'
  
    fs.readFile "#{__dirname}/fixtures/simple_01.html", (err, result) ->
      div = document.createElement('div')
      div.innerHTML = result.toString()
      document.querySelector('body').appendChild(div.firstChild)
      
      adUnit = document.querySelector('#ad-unit')
      
      maximus(adUnit)
      
      adUnit.getBoundingClientRect().left.should.equal(0)
      adUnit.offsetWidth.should.equal(document.documentElement.clientWidth)
    
      done()
  
  # it 'should fit element on resize', ->
  #   fs = require 'fs'
  # 
  #   fs.readFile "#{__dirname}/fixtures/simple_01.html", (err, result) ->
  #     div = document.createElement('div')
  #     div.innerHTML = result.toString()
  #     document.querySelector('body').appendChild(div.firstChild)
  #     
  #     adUnit = document.querySelector('#ad-unit')
  #     
  #     maximus(adUnit)
  #     
  #     document.querySelector('div:first-of-type').style.marginLeft = '20px'
  #     document.querySelector('div:first-of-type').style.marginRight = '10px'
  #     
  #     window.dispatchEvent(new Event('resize'))
  #     
  #     setTimeout ->
  #       adUnit.getBoundingClientRect().left.should.equal(0)
  #       adUnit.offsetWidth.should.equal(document.documentElement.clientWidth)
  #     , 65    