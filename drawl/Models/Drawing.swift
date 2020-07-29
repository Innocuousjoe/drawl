import UIKit

struct Drawing {
    var id: String = UUID().uuidString
    let thumbnail: UIImage
    let creationDate: Date
    let interval: DateInterval
    let lineArray: [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]]
    
    static func primaryKey() -> String? {
        return "id"
    }
}

extension Drawing: Equatable {
    static func ==(leftHandSide: Drawing, rightHandSide: Drawing) -> Bool {
        return leftHandSide.thumbnail == rightHandSide.thumbnail && leftHandSide.creationDate == rightHandSide.creationDate && leftHandSide.interval == rightHandSide.interval
    }
}
