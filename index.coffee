verge = require 'verge'

Max =
  trackedElements: []
  hasResizeHandler: false
  
  track: (element) ->
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
    console.log 'on resize!'
    if not Max._tickingResize
      requestAnimationFrame =>
        Max._tickingResize = false
        Max._onResize()
        
    Max._tickingResize = true
      
  maximize: (element) ->
    # Create placeholder div next to element
    placeholderAttr = 'data-maximize-placeholder'
    
    if element.previousSibling?.hasAttribute?(placeholderAttr)
      placeholder = element.previousSibling
    else
      placeholder = document.createElement('div')
      placeholder.setAttribute(placeholderAttr,'')
      element.parentNode.insertBefore(placeholder, element)
    
    # Adjust the left and right margin so box is stretched to the whole screen
    rect = verge.rectangle(placeholder)
    
    element.style.marginLeft = rect.left * -1 + 'px'
    
    element.style.marginRight = (verge.viewportW() - placeholder.offsetWidth - rect.left) * -1 + 'px'
    
    # element.style.marginLeft = placeholder.offsetLeft * -1 + 'px'
    # element.style.width = top.document.documentElement.clientWidth + 'px'
    # 
    
  reset: (element) ->
    # Reset to original state
    Max.trackedElements = []
    Max.hasResizeHandler = false
    
    top.window.removeEventListener 'resize', Max.onResize if Max.hasResizeHandler
    
Max.track.reset = Max.reset

module.exports = Max.track