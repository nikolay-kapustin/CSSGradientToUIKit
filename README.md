#  CSSGradientToUIKit
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)
![Xcode 12.0+](https://img.shields.io/badge/Xcode-12%2B-blue.svg)
![iOS 10.0+](https://img.shields.io/badge/iOS-10.0%2B-blue.svg)
[![License](https://img.shields.io/cocoapods/l/BadgeSwift.svg?style=flat)](/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/BadgeSwift.svg?style=flat)](http://cocoadocs.org/docsets/BadgeSwift)

The main idea of this converter is adopt the same gradient from Web to iOS. The CSS has [linear-gradient()](https://developer.mozilla.org/ru/docs/Web/CSS/linear-gradient)
 func to create gradient.
 ## Web CSS
 ```javascript
 background: linear-gradient(-275DEG, red, yellow);
 background: linear-gradient(35deg, red, yellow);
 background: linear-gradient(680deg, red, yellow);
 ```
 Unlike UIKit has another coordinate subsystem for CGGradientLayer:

```swift
gradientLayer.startPoint = CGPoint(x:0, y:0.559)
gradientLayer.endPoint = CGPoint(x:1, y:0.441)
// and so on
```

### Example of -275 degree

![css -275 gradient][css-275]

## Usage

```swift
let size = CGSize(width: 200, height: 100)
let gradient = CAGradientLayer()
gradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]

let points = gradientPoints(size: gradient.bounds.size, cssAngle: -275)
gradient.startPoint = points.start
gradient.endPoint = points.end
```

## License

**CSSGradientToUIKit** is released under the [MIT License](LICENSE).


[css-275]: https://github.com/nikolay-kapustin/CSSGradientToUIKit/blob/master/css-275.png?raw=true ""
