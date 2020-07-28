import UIKit

struct Drawing {
    let thumbnail: UIImage
    let creationDate: Date
    let interval: DateInterval
    let lineArray: [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]]
}
