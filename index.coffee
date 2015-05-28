verge = require 'verge'
raf = require 'raf'

Max =
  trackedElements: []
  hasResizeHandler: false
  
  track: (element) ->
    # Maximize element now and any time the window gets resized
    if not element?.offsetWidth?
      element = document.querySelector(element)
    
    Max.trackedElements.push(element)
    
    # Add a global resize handler which will maximize elements when the window
    # is resized.. Sort of like a run-loop since it uses requestAnimationFrame.
    top.window.addEventListener 'resize', Max.onResize if not Max.hasResizeHandler
    Max.hasResizeHandler = true
    
    Max.maximize(element)
  
  _onResize: ->
    for element in Max.trackedElements
      @maximize(element)
    
  onResize: ->
    if not Max._tickingResize
      raf ->
        Max._tickingResize = false
        Max._onResize()
        
    Max._tickingResize = true
      
  maximize: (element) ->
    # Create placeholder div next to element
    placeholderAttr = 'data-maximize-placeholder'
    
    if element.previousSibling?.hasAttribute?(placeholderAttr)
      placeholder = element.previousSibling
    else
      placeholder = top.document.createElement('div')
      placeholder.setAttribute(placeholderAttr,'')
      element.parentNode.insertBefore(placeholder, element)
    
    # Adjust the left and right margin so box is stretched to the whole screen
    rect = verge.rectangle(placeholder)
    
    element.style.marginLeft = rect.left * -1 + 'px'

    viewportWidth = top.document.documentElement.clientWidth
    
    element.style.marginRight = (viewportWidth - placeholder.offsetWidth - rect.left) * -1 + 'px'
    
  reset: (element) ->
    # Reset to original state
    Max.trackedElements = []
    Max.hasResizeHandler = false
    
    top.window.removeEventListener 'resize', Max.onResize if Max.hasResizeHandler
    
[Max.track.reset, Max.track.onResize] = [Max.reset, Max.onResize]

module.exports = Max.track