verge = require 'verge'
raf = require 'raf'

Max =
  trackedElements: []
  hasResizeHandler: false

  track: (element) ->
    # If it's not a DOM element.. it's probably a selector, so search the
    # current doc as well as the parent doc for that element.
    if not element?.offsetWidth?
      docs = [top.document,document]

      for doc in docs
        if (_element = doc.querySelector(element))?.offsetWidth?
          element = _element
          break
          
    # Return if it's not a valid DOM element
    return false if not element?.offsetWidth?

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

# Copy over functions to Max.track as well, that way you can do
# something like require('maximus').reset()
[Max.track.reset, Max.track.onResize] = [Max.reset, Max.onResize]

module.exports = Max.track
