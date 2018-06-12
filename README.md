# ZGTooltipView

[![CI Status](http://img.shields.io/travis/Alexandre Guibert/ZGTooltipView.svg?style=flat)](https://travis-ci.org/Alexandre Guibert/ZGTooltipView)
[![Version](https://img.shields.io/cocoapods/v/ZGTooltipView.svg?style=flat)](http://cocoapods.org/pods/ZGTooltipView)
[![License](https://img.shields.io/cocoapods/l/ZGTooltipView.svg?style=flat)](http://cocoapods.org/pods/ZGTooltipView)
[![Platform](https://img.shields.io/cocoapods/p/ZGTooltipView.svg?style=flat)](http://cocoapods.org/pods/ZGTooltipView)

## Example

![Screenshot](https://github.com/Zigzag968/ZGTooltipView/blob/master/Example/Screenshot.png?raw=true)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use ?

Just call on your view :

    myView.setTooltip(ZGTooltipView(direction: .Top, text: "Lorem ipsum dolor sit amet"))

You can use these directions : 

    .Top, .Left, .Right, .Bottom, .TopLeft, .TopRight, .BottomLeft, .BottomRight

If you want to display the tooltip into another view than the one you are attaching it to (like a parent to avoid your tooltip to be clipped), you can pass it as the second parameter when setting it to your view:    

    myView.setTooltip(ZGTooltipView(direction: .Top, text: "Lorem ipsum dolor sit amet"), displayInView: myView.superview)

## Requirements

## Installation

ZGTooltipView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ZGTooltipView"
```

## Author

Alexandre Guibert, alexandre@evaneos.com

## License

Tooltip view for iOS
ZGTooltipView is available under the MIT license. See the LICENSE file for more info.
