import UIKit

class DrawingView: UIView {
    var strokeColor: CGColor = UIColor.black.cgColor
    
    private var lineArray: [[(point: CGPoint, strokeColor: CGColor)]] = [[(point: CGPoint, strokeColor: CGColor)]]()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let firstPoint = touch.location(in: self)

        lineArray.append([(point: CGPoint, strokeColor: CGColor)]())
        lineArray[lineArray.count - 1].append((point: firstPoint, strokeColor: strokeColor))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        lineArray[lineArray.count - 1].append((point: currentPoint, strokeColor: strokeColor))
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        draw(inContext: context)
    }

    func draw(inContext context: CGContext) {
        context.setLineWidth(5)
        
        context.setLineCap(.round)
        for line in lineArray {
            guard let firstPoint = line.first else { continue }
            context.setStrokeColor(firstPoint.strokeColor)
            context.beginPath()
            context.move(to: firstPoint.point)
            
            for point in line.dropFirst() {
                context.addLine(to: point.point)
            }
            context.strokePath()
        }
    }
    
    //MARK: Helpers
    func setColor(newColor: CGColor) {
        self.strokeColor = newColor
    }
}
