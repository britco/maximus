## maximus

Expands an element to the full size of the viewport. Useful if for example you have an ad unit deeply nested inside HTML that includes multiple `position: relative` divs.

I.E.

````html
<div style="margin-left: 100px">
  <div style="position: relative">
    <div class="ad-unit">
    </div>
  </div>
</div>
````


## How to use

Either specify a selector or a `DOMElement`.

````coffee
maximus = require('maximus')
maximus('.ad-unit')
maximus(document.querySelector('.ad-unit'))
````

## License
Available under the MIT License.