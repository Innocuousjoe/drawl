import UIKit

protocol TabBarControllerDelegate: class {
    func redraw(with lineArray: [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]])
}

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let drawingListViewController = self.viewControllers?.last as? DrawingListTableViewController
        
        if let dlvc = drawingListViewController {
            dlvc.tabBarDelegate = self
        }
    }
    
}

extension TabBarController: TabBarControllerDelegate {
    func redraw(with lineArray: [[(point: CGPoint, strokeColor: CGColor, strokeSize: CGFloat)]]) {
        selectedIndex = 0
        let sketchPadViewController = self.viewControllers?.first as? SketchPadViewController
        
        if let spvc = sketchPadViewController {
            spvc.redraw(with: lineArray)
        }
    }
}
