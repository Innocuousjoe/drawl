import UIKit

class DrawingView: UIView {
    var strokeColor: CGColor = UIColor.black.cgColor
    var strokeSize: CGFloat = 5
    var startTime: Date!
    
    private var lineArray: [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]] = [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]]()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let firstPoint = touch.location(in: self)

        lineArray.append([(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]())
        lineArray[lineArray.count - 1].append((point: firstPoint, strokeColor: strokeColor, strokeSize: strokeSize))
        if startTime == nil {
            startTime = Date()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        lineArray[lineArray.count - 1].append((point: currentPoint, strokeColor: strokeColor, strokeSize: strokeSize))
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        draw(inContext: context)
    }

    func draw(inContext context: CGContext) {
        context.setLineCap(.round)
        for line in lineArray {
            guard let firstPoint = line.first else { continue }
            context.setLineWidth(firstPoint.strokeSize)
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
    
    func setStrokeSize(newSize: CGFloat) {
        self.strokeSize = newSize
    }
    
    func resetDrawing() {
        lineArray = []
        setNeedsDisplay()
    }

    func exportDrawing() -> (startTime: Date, image: UIImage, lineArray: [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]])? {
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        draw(inContext: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            return (startTime: startTime, image: image, lineArray: lineArray)
        } else {
            return nil
        }
    }
}
