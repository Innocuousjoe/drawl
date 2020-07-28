protocol DrawingCacheProtocol: class {
    func getDrawings() -> [Drawing]
    func add(drawing: Drawing)
    func drawingCount() -> Int
}

class DrawingCache: DrawingCacheProtocol {
    
    static let shared = DrawingCache()
    private var drawings: [Drawing] = [Drawing]()
    
    func getDrawings() -> [Drawing] {
        return drawings
    }
    
    func add(drawing: Drawing) {
        drawings.append(drawing)
    }
    
    func drawingCount() -> Int {
        return drawings.count
    }
}
