# TOMSMorphingLabel
TOMSMorphingLabel provides configurable morphing transitions between string values.
Triggering the animation is as easy as setting the labels `text` property.
TOMSMorphingLabel is written in Swift :)

## Demo

![Screen1](demo.gif)

## Installation with CocoaPods

TOMSMorphingLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

#### Podfile

```ruby
platform :ios, '7.0'
pod "TOMSMorphingLabel", "~> 0.1.0"
```

## Usage

Instantiate TOMSMorphingLabel as you would do with an UILabel results in a fully working thus morphing label.

```objective-c
var label = TOMSMorphingLabel(frame: CGRect(x: 0, y: 42, width: self.view.frame.size.width, height: 42))
self.view.addSubview(label)
```

Setting - and particularly changing - the labels text property will automatically morph the labels previous text to the new value.

```objective-c
label.text = "Swift"
```

Note that the label will execute only one morph transition at a time. If the text value of the label changes during a transition - even if it changes multiple times - the label will invoke a transition to the youngest text value that was set.

## Customization

TOMSMorphingLabel's designated initializer provides the possibility to configure the morphing transitions look and feel.
The designated initializer is defined as follows:

```objective-c
init(frame: CGRect, animationDuration: Double, characterAnimationOffset: Double = 0.25, characterShrinkFactor: Double = 4, fps: Int = 60)
```
<table>
  <caption>Customizable parameters</caption>
  <tr>
    <td><tt>`animationDuration` = 0.36</tt></td>
    <td>Time that elapses between the setting of a new text value and the end of the morphing transition. </td>
  </tr>
  <tr>
    <td><tt>`characterAnimationOffset` = 0.25</tt></td>
    <td>Spatial propagation speed of the character shrink and alpha effekt.</td>
  </tr>
  <tr>
    <td><tt>`characterShrinkFactor` = 4</tt></td>
    <td>Factor that the scale of a completely disappeared character is divided by.</td>
  </tr>
  <tr>
    <td><tt>`fps` = 60</tt></td>
    <td>Frames per second. Number of executions of the animations stages within a second.</td>
  </tr>
</table>


## Author

[Tom König](http://github.com/TomKnig) [@TomKnig](https://twitter.com/TomKnig)

## License

TOMSMorphingLabel is available under the MIT license. See the LICENSE file for more info.
