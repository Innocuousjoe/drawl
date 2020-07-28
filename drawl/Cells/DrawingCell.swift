import UIKit

class DrawingCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var drawingDurationLabel: UILabel!
    
    func configure(with drawing: Drawing) {
        thumbnail.image = drawing.thumbnail
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        
        createdAtLabel.text = "Created on \(formatter.string(from: drawing.creationDate))"
        
        let start = drawing.interval.start
        let end = drawing.interval.end
        drawingDurationLabel.text = "Drawing took \(end.offsetFrom(date: start))"
        
        styleView()
    }
    
    private func styleView() {
        thumbnail.layer.borderColor = UIColor.black.cgColor
        thumbnail.layer.borderWidth = 1
    }
}
