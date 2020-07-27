import UIKit

class SketchPadViewController: UIViewController {
    
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var dockView: UIView!
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var brushSizeLabel: UILabel!
    @IBOutlet weak var eraserButton: UIButton!
    
    private var lineArray: [[CGPoint]] = [[CGPoint]]()
    private var selectedColor: CGColor = UIColor.black.cgColor
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleView()
    }
    
    @IBAction func colorSelected(_ sender: UIButton) {
        if let backgroundColor = sender.backgroundColor {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let firstPoint = touch.location(in: drawingView)

        lineArray.append([CGPoint]())
        lineArray[lineArray.count - 1].append(firstPoint)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: drawingView)
        
        lineArray[lineArray.count - 1].append(currentPoint)
        drawingView.setNeedsDisplay()
    }
    
    private func styleView() {
        dockView.addTopBorder(with: UIColor.black, andWidth: 1)
        
        brushSizeLabel.text = "\(5)"
        
        brushSizeSlider.isContinuous = true
        brushSizeSlider.value = 5
        drawingView.setStrokeSize(newSize: 5)
    }
}
