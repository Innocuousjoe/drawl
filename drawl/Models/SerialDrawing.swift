import Unrealm
import UIKit

struct SerialDrawing: Realmable {
    init() {
        self.id = ""
        self.thumbnail = Data.init()
        self.creationDate = Date()
        self.intervalStart = Date()
        self.intervalEnd = Date()
        self.lineArray = [SerialPoint]()
    }
    
    var id: String
    var thumbnail: Data
    var creationDate: Date
    var intervalStart: Date
    var intervalEnd: Date
    var lineArray: [SerialPoint]
    
    init(_ drawing: Drawing) {
        self.id = drawing.id
        self.thumbnail = drawing.thumbnail.pngData()!
        self.creationDate = drawing.creationDate
        self.intervalStart = drawing.interval.start
        self.intervalEnd = drawing.interval.end
        self.lineArray = [SerialPoint]()
        
        for (index, subArray) in drawing.lineArray.enumerated() {
            for tuple in subArray {
                var newSerialPoint = SerialPoint()
                newSerialPoint.x = Float(tuple.point.x)
                newSerialPoint.y = Float(tuple.point.y)
                newSerialPoint.strokeSize = Float(tuple.strokeSize)
                newSerialPoint.strokeColor = "\(tuple.strokeColor)"
                newSerialPoint.index = index
                
                self.lineArray.append(newSerialPoint)
            }
        }
    }
}

struct SerialPoint: Realmable {
    var index: Int
    var x: Float
    var y: Float
    var strokeColor: String
    var strokeSize: Float
    
    init() {
        self.index = 0
        self.x = 0
        self.y = 0
        self.strokeColor = ""
        self.strokeSize = 0
    }
}
