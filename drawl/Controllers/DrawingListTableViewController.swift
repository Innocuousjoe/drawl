import UIKit
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}

class DrawingListTableViewController: UITableViewController {
    
    let drawingDeserializer: DrawingDeserializerProtocol = DrawingDeserializer()
    
    let drawingCache = DrawingCache.shared
    var drawings: [Drawing] = [Drawing]()
    var tabBarDelegate: TabBarControllerDelegate?
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let realm = try! Realm()
        let dbDrawings = realm.objects(SerialDrawing.self)
        drawingDeserializer.deserialize(serialDrawings: Array(dbDrawings))
        
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
            let drawing = drawings[indexPath.row]
            drawings = drawingCache.remove(drawing: drawing)
            let realm = try! Realm()
            
            let serialDrawing = SerialDrawing.init(drawing)
            try! realm.write {
                realm.delete(serialDrawing)
            }
            
            tableView.reloadData()
        }
    }
}
