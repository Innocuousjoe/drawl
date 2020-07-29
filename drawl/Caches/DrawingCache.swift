protocol DrawingCacheProtocol: class {
    func getDrawings() -> [Drawing]
    func add(drawing: Drawing)
    func drawingCount() -> Int
    func remove(drawing: Drawing) -> [Drawing]
}

class DrawingCache: DrawingCacheProtocol {
    
    static let shared = DrawingCache()
    private var drawings: [Drawing] = [Drawing]()
    
    func getDrawings() -> [Drawing] {
        return drawings
    }
    
    func add(drawing: Drawing) {
        if !drawings.contains(where: { (insideDrawing) -> Bool in
            insideDrawing.id == drawing.id
        }) {
            drawings.append(drawing)
        }
    }
    
    func drawingCount() -> Int {
        return drawings.count
    }
    
    func remove(drawing: Drawing) -> [Drawing] {
        drawings = drawings.filter { (internalDrawing) -> Bool in
            internalDrawing != drawing
        }
        
        return drawings
    }
}
