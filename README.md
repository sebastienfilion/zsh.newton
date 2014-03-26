### Viral Ninjas UI
## Panel

The Panel module takes a ```div``` and its content and turn it as a poping panel
*Note* The motion of the panel is not define by this module but with CSS3 declaration, by default the panel has a ```transition: bottom 0.5s``` declaration assigned to it.

#### Usage example

```html
<von-panel handle="Open!|Close!" visible="hide">
    My content!
</von-panel>
```

```css
von-panel { height: 150px; }
von-panel .von-panel-handle { height: 20px; }
von-panel.show { bottom: 0; }
von-panel.hide { bottom: -130px; }
```

The ```handle``` attributes allows to customize the text of the handle. It default to ```"Open|Close"```.
The ```visible``` attributes dictate if the panel should be in the ```hide``` or ```show``` state.
The default template can be overwritten by creating a local template with an id of ```vonPanelTmpl```. Check example:

```html
<script id="vonPanelTmpl" type="text/template">
    <div>
        <div class="von-panel-handle"><span>{{handle}}</span></div>
        <div ng-transclude></div>
    </div>
</script>
```
