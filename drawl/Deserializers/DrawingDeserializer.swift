import UIKit

protocol DrawingDeserializerProtocol: class {
    func deserialize(serialDrawings: [SerialDrawing])
}

class DrawingDeserializer: DrawingDeserializerProtocol {
    let drawingCache: DrawingCacheProtocol = DrawingCache.shared
    
    func deserialize(serialDrawings: [SerialDrawing]) {
        for serial in serialDrawings {
            var deserializedLineArray = [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]]()
            
            for serialPoint in serial.lineArray {
                if deserializedLineArray.count <= serialPoint.index {
                    deserializedLineArray.append([(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]())
                }
                
                let point = CGPoint(x: CGFloat(serialPoint.x), y: CGFloat(serialPoint.y))
                let strokeSize = CGFloat(serialPoint.strokeSize)
                var strokeColor = UIColor.black.cgColor
                
                switch serialPoint.strokeColor {
                case "purple":
                    strokeColor = UIColor.systemPurple.cgColor
                case "red":
                    strokeColor = UIColor.systemRed.cgColor
                case "orange":
                    strokeColor = UIColor.systemOrange.cgColor
                case "yellow":
                    strokeColor = UIColor.systemYellow.cgColor
                case "green":
                    strokeColor = UIColor.systemGreen.cgColor
                case "blue":
                    strokeColor = UIColor.systemBlue.cgColor
                default:
                    ()
                }
                
                deserializedLineArray[serialPoint.index].append((point: point, strokeColor: strokeColor, strokeSize: strokeSize))
            }

            var newDrawing = Drawing(thumbnail: UIImage(data: serial.thumbnail)!,
                                     creationDate: serial.creationDate,
                                     interval: DateInterval(start: serial.intervalStart, end: serial.intervalEnd),
                                     lineArray: deserializedLineArray)
            newDrawing.id = serial.id
            
            drawingCache.add(drawing: newDrawing)
        }
    }
}
