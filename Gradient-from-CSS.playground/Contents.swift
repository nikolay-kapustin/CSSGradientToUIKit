//: # CSS linear-gradient to UIKit coordinate space conversion
  
import UIKit
import PlaygroundSupport

//handy radians
func radian(degree:Double) -> Double {    return degree * Double.pi / 180 }
func radian(degree:CGFloat) -> CGFloat {   return degree * CGFloat(Double.pi / 180) }

func gradientPoints(size:CGSize, cssAngle:CGFloat) -> (start:CGPoint, end:CGPoint) {
    //default value of gradients from CAGradientLayer
    var start = CGPoint(x:0.0, y:1.0)
    var end = CGPoint(x:0.0, y:0.0)

    // we must to make normolization the angle (if angle over 360deg)
    let normalizedAngle = cssAngle.truncatingRemainder(dividingBy: 360) // if value lower than 360, truncating return the same
    // special tuple for computation angle and flag, indicating top side angle or not (see picture)
    var directionAngle:(angle:CGFloat, topSide:Bool) = (normalizedAngle, true)

    let angleDiff:CGFloat = abs(normalizedAngle) > 270.0 ? 360.0:180.0 // shorthand for diff for equathion

    // next we should computate the angle and their side (top side or not) by considering the sign of incoming angle
    if (90.0...270.0).contains(normalizedAngle) { // these angles - bottom side of half
        directionAngle = (normalizedAngle - angleDiff, false) // differ used for additional normalization angle for this range (90...270)
    }
    // the angles, which is more then of pi, we make it as top angle (diff = 360), so we get nagative angle value
    else if normalizedAngle > 270 {directionAngle = (normalizedAngle - angleDiff, true)}
    // and we make the same for negative anlges
    else if normalizedAngle < -90 && normalizedAngle > -270 {
        directionAngle = (abs(abs(normalizedAngle) - angleDiff), false) // note: here,we use ABS to cast the valid angle to bottom side, unlike 90..270 positive angles (see above)
    }
    else if normalizedAngle <= -270 {directionAngle = (abs(abs(normalizedAngle) - angleDiff), true)} // in fact the same rules
    else {
        directionAngle = normalizedAngle > 0 ? (normalizedAngle, true):(normalizedAngle, true) // other angles between -90 and 90
    }

    // for that point we get angle betwwen -90 and 90 and the side (top or bottoms)
    switch directionAngle.angle {
    case 90, -90.0: // simples values
        start = CGPoint(x: (90-directionAngle.angle)/180, y: 0.5)
        end = CGPoint(x: (90+directionAngle.angle)/180, y: 0.5)
        break
    case -90..<90:
        var angle = radian(degree: directionAngle.angle)
        var tAngle = tan(angle)
        guard tAngle != CGFloat.nan else {
            start = CGPoint(x: 1, y: 0.5)
            end = CGPoint(x: 0, y: 0.5)
            break
        }
        // set default values for closest range
        start.y = 1
        end.y = 0
        // computate the part of head or tile by angle and sizings (see pic)
        let valueX = (size.width/2 - (size.height/2 * tAngle)) / size.width

        // computate next pair values of points
        start.x = valueX < 0 ? 0 : (valueX >= 1 ? 1 : valueX) // perl come with me
        end.x = valueX < 0 ? 1 : (valueX >= 1 ? 0 : 1-valueX)

        // next we must check some special cases for too many angles (see pic)
        if valueX < 0  || valueX > 1 {
            angle = radian(degree: 90 - abs(directionAngle.angle))
            tAngle = tan(angle)
            let valueY = (size.height/2 - (size.width/2 * tAngle)) / size.height
            start.y = 1 - valueY
            end.y = valueY
        }
    default:
        break
    }
    // if topside == false, we need swap start and end points
    return directionAngle.topSide ? (start, end):(end,start)
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let block = UIView()
        let size = CGSize(width: 200, height: 100)
        block.frame = CGRect(x: 0, y: 200, width: size.width, height: size.height)
        //label.text = "Hello World!"
        block.backgroundColor = .white
        let gradient = CAGradientLayer()
        gradient.frame = block.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]

        let points = gradientPoints(size: gradient.bounds.size, cssAngle: -275)
        gradient.startPoint = points.start
        gradient.endPoint = points.end

        block.layer.addSublayer(gradient)
        view.addSubview(block)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


//: ## Illustration of alhorithm
/*:

 ![Illustration of alhorithm](calc.png)

*/
