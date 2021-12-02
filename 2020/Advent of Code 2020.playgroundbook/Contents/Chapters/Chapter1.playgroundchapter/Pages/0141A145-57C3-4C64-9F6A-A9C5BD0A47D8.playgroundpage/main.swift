// Day 24
let tileInstructions = Day24Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

enum Direction {
    case nw
    case ne
    case se
    case sw
    case e
    case w
}

struct Location: Hashable {
    let x: Int
    let y: Int
    
    func movedInDirection(direction: Direction) -> Location {
        let newLocation: Location
        let isEven = y % 2 == 0
        switch direction {
        case .e:
            newLocation = Location(x: x + 1, y: y)
        case .w:
            newLocation = Location(x: x - 1, y: y)
        case .ne:
            newLocation = Location(x: x + (isEven ? 1 : 0), y: y - 1)
        case .nw:
            newLocation = Location(x: x - (isEven ? 0 : 1), y: y - 1)
        case .se:
            newLocation = Location(x: x + (isEven ? 1 : 0), y: y + 1)
        case .sw:
            newLocation = Location(x: x - (isEven ? 0 : 1), y: y + 1)
        }
        return newLocation
    }
    
    var neighbors: [Location] {
        [
            movedInDirection(direction: .e),
            movedInDirection(direction: .w),
            movedInDirection(direction: .ne),
            movedInDirection(direction: .nw),
            movedInDirection(direction: .se),
            movedInDirection(direction: .sw),
        ]
    }
    
    var description: String {
        return "(x: \(x),y: \(y))"
    }
}

struct Floor {
    // true means the tile is black
    let tileDict: [Location:Bool]
    
    func advanceDay() -> Floor {
        var newDayTileDict: [Location:Bool] = [:]
        
        let setOfNewLocations = tileDict.keys.reduce(Set<Location>()) { oldSet, location in
            oldSet.union([location] + location.neighbors)
        }
        
        setOfNewLocations.forEach { location in
            let blackTileNeighbors = location.neighbors.reduce(0) {
                $0 + (tileDict[$1] == true ? 1 : 0)
            }
            
            if tileDict[location] == true {
                if blackTileNeighbors != 0 && blackTileNeighbors <= 2 {
                    newDayTileDict[location] = true
                }
            } else {
                if blackTileNeighbors == 2 {
                    newDayTileDict[location] = true
                }
            }
        }
        
        return Floor(tileDict: newDayTileDict)
    }
    
    var numberOfBlackTiles: Int {
        tileDict.values.filter {$0}.count
    }
}

var floor0: Floor? = nil

// Part 1
measure("Part 1") {
    let directions: [[Direction]] = tileInstructions.map {
        var directions: [Direction] = []
        var mutableInstruction = $0
        while mutableInstruction.count > 0 {
            let first = mutableInstruction.first!
            mutableInstruction.removeFirst()
            if first == "n" {
                let second = mutableInstruction.first!
                mutableInstruction.removeFirst()
                if second == "e" {
                    directions.append(.ne)
                } else {
                    directions.append(.nw)
                }
            } else if first == "s" {
                let second = mutableInstruction.first!
                mutableInstruction.removeFirst()
                if second == "e" {
                    directions.append(.se)
                } else {
                    directions.append(.sw)
                }
            } else {
                if first == "e" {
                    directions.append(.e)
                } else {
                    directions.append(.w)
                }
            }
        }
        return directions
    }
    
    let destinationsToFlip = directions.map { directionList in
        directionList.reduce(Location(x: 0, y: 0)) { oldLocation, direction in
            oldLocation.movedInDirection(direction: direction)
        }
    }
    
    var dict: [Location:Bool] = [:]
    destinationsToFlip.forEach {
        if let isFlipped = dict[$0] {
            dict[$0] = !isFlipped
        } else {
            dict[$0] = true
        }
    }
    
    floor0 = Floor(tileDict: dict)
    
    print("Part 1 answer is: \(floor0?.numberOfBlackTiles)")
}

// Part 2
measure("Part 2") {
    guard let floor0 = floor0 else {
        return
    }
    
    let hundredthFloor = (0..<100).reduce(floor0) { previousFloor, _ in
        previousFloor.advanceDay()
    }
    
    print("Part 2 answer is: \(hundredthFloor.numberOfBlackTiles)")
}

