import UIKit

class DrawingListTableViewController: UITableViewController {
    
    let drawingCache = DrawingCache.shared
    var drawings: [Drawing] = [Drawing]()
    var tabBarDelegate: TabBarControllerDelegate?
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        drawings = drawingCache.getDrawings()
        tableView.reloadData()
    }
    
    //MARK: TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drawings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawingCell")
        if let drawingCell = cell as? DrawingCell {
            drawingCell.configure(with: drawings[indexPath.row])
            
            return drawingCell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = tabBarDelegate {
            let drawing = drawings[indexPath.row]
            delegate.redraw(with: drawing.lineArray)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            drawings = drawingCache.remove(drawing: drawings[indexPath.row])
            tableView.reloadData()
        }
    }
}
