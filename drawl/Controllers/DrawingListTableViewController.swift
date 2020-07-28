import UIKit

class DrawingListTableViewController: UITableViewController {
    
    let drawingCache = DrawingCache.shared
    var drawings: [Drawing] = [Drawing]()
    
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
}
