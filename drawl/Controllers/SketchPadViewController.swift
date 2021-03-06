import UIKit
import RealmSwift

class SketchPadViewController: UIViewController {
    
    private let drawingCache: DrawingCacheProtocol = DrawingCache.shared
    
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var dockView: UIView!
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var brushSizeLabel: UILabel!
    @IBOutlet weak var eraserButton: UIButton!
    
    private var selectedColor: CGColor = UIColor.black.cgColor
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleView()
    }
    
    //MARK: IBActions
    @IBAction func colorSelected(_ sender: UIButton) {
        if let backgroundColor = sender.backgroundColor {
            eraserButton.setBackgroundImage(UIImage(named: "unchecked"), for: .normal)
            selectedColor = backgroundColor.cgColor
            
            switch backgroundColor.cgColor {
            case UIColor.systemPurple.cgColor:
                drawingView.setColor(newColor: UIColor.systemPurple.cgColor)
            case UIColor.systemRed.cgColor:
                drawingView.setColor(newColor: UIColor.systemRed.cgColor)
            case UIColor.systemOrange.cgColor:
                drawingView.setColor(newColor: UIColor.systemOrange.cgColor)
            case UIColor.systemYellow.cgColor:
                drawingView.setColor(newColor: UIColor.systemYellow.cgColor)
            case UIColor.systemGreen.cgColor:
                drawingView.setColor(newColor: UIColor.systemGreen.cgColor)
            case UIColor.systemBlue.cgColor:
                drawingView.setColor(newColor: UIColor.systemBlue.cgColor)
            case UIColor.black.cgColor:
                drawingView.setColor(newColor: UIColor.black.cgColor)
            default:
                ()
            }
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        brushSizeLabel.text = "\(Int(sender.value))"
        drawingView.setStrokeSize(newSize: CGFloat(sender.value))
    }
    
    @IBAction func tappedEraser(_ sender: Any) {
        if let backgroundImage = eraserButton.backgroundImage(for: .normal), backgroundImage == UIImage(named: "unchecked") {
            eraserButton.setBackgroundImage(UIImage(named: "checked"), for: .normal)
            if let drawingBackground = drawingView.backgroundColor {
                drawingView.setColor(newColor: drawingBackground.cgColor)
            } else {
                drawingView.setColor(newColor: UIColor.white.cgColor)
            }
        } else {
            eraserButton.setBackgroundImage(UIImage(named: "unchecked"), for: .normal)
            drawingView.setColor(newColor: selectedColor)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if let tuple = drawingView.exportDrawing() {
            let start = tuple.startTime
            let end = Date()
            let interval = DateInterval(start: start, end: end)
            let drawing = Drawing(thumbnail: tuple.image, creationDate: Date(), interval: interval, lineArray: tuple.lineArray)
            
            drawingCache.add(drawing: drawing)
            drawingView.resetDrawing()
            
            let realm = try! Realm()
            let serialDrawing = SerialDrawing.init(drawing)
            try! realm.write {
                realm.add(serialDrawing)
            }
        }
    }
    
    @IBAction func reset() {
        brushSizeSlider.value = 5
        brushSizeLabel.text = "\(5)"
        drawingView.setStrokeSize(newSize: 5.0)
        drawingView.setColor(newColor: UIColor.black.cgColor)
        drawingView.resetDrawing()
    }
    
    //MARK: Helpers
    func redraw(with lineArray: [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]]) {
        reset()
        let reduced = lineArray.reduce([], +)
        let increment: Float = 1.0 / Float(reduced.count)
        let interval = TimeInterval(exactly: increment)
        var index = 0
        var overIndex = 0
        Timer.scheduledTimer(withTimeInterval: interval!, repeats: true) { (timer) in
            if overIndex < lineArray.count, index != lineArray[overIndex].count {
                if self.drawingView.lineArray.count <= overIndex {
                    self.drawingView.lineArray.append([(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]())
                }
                
                self.drawingView.lineArray[overIndex].append(lineArray[overIndex][index])
                self.drawingView.setNeedsDisplay()
                index += 1
            } else if overIndex < lineArray.count {
                index = 0
                overIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func styleView() {
        dockView.addTopBorder(with: UIColor.black, andWidth: 1)
        
        brushSizeLabel.text = "\(5)"
        
        brushSizeSlider.isContinuous = true
        brushSizeSlider.value = 5
        drawingView.setStrokeSize(newSize: 5)
    }
}
