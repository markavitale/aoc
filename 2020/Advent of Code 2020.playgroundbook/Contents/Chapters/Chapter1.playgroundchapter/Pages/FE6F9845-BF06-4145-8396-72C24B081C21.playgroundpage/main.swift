// Day 17

let initialInput = Day17Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap {row in row.compactMap {character in character == "#" ? 1 : 0 } }

var initialInputPoints: [Point:Int] = [:]
initialInput.enumerated().forEach { row in
    row.element.enumerated().compactMap {
        initialInputPoints[Point(x: $0.offset, y: row.offset, z:0)] = $0.element
    }
}

let possibleNeighbors = [-1,0,1]
var neighborOffsets: [Point] = []
for possibleNeighborX in possibleNeighbors {
    for possibleNeighborY in possibleNeighbors {
        for possibleNeighborZ in possibleNeighbors {
            if possibleNeighborX == possibleNeighborY,
               possibleNeighborX == possibleNeighborZ,
               possibleNeighborX == 0 {
                // 0,0,0 isn't a neighbor, it's us!
                continue
            }
            neighborOffsets.append(Point(x: possibleNeighborX, y: possibleNeighborY, z: possibleNeighborZ))
        }
    }
}

struct Point: Equatable, Hashable {
    let x: Int
    let y: Int
    let z: Int
    
    func point(from offset: Point) -> Point {
        return Point(x: x + offset.x, y: y + offset.y, z: z+offset.z)
    }
}

struct ThreeDimensionalPlane {
    let points: [Point:Int]
    
    func isActive(point: Point) -> Bool {
        return points[point] == 1
    }
    
    func numberOfActiveNeighbors(at point: Point) -> Int {
        return neighborOffsets.reduce(0) { accumulator, neighborOffset in
            let offsetPoint = point.point(from: neighborOffset)
            return accumulator + (isActive(point: offsetPoint) ? 1 : 0)
        }
    }
    
    func pointsWithNeighbors() -> [Point:Int] {
        var newPoints = points
        points.forEach { point in
            neighborOffsets.forEach { offset in
                let offsetPoint = point.key.point(from: offset)
                if !newPoints.keys.contains(offsetPoint) {
                    newPoints[offsetPoint] = 0
                }
            }
        }
        return newPoints
    }
    
    func advance() -> ThreeDimensionalPlane {
        var newPoints = points
        for (point, _) in pointsWithNeighbors() {
            let activeNeighbors = numberOfActiveNeighbors(at: point)
            let isCurrentlyActive = isActive(point: point)
            if isCurrentlyActive, activeNeighbors == 2 || activeNeighbors == 3 {
                newPoints[point] = 1
            } else if !isCurrentlyActive, activeNeighbors == 3 {
                newPoints[point] = 1
            } else {
                newPoints[point] = 0
            }
        }
        return ThreeDimensionalPlane(points: newPoints)
    }
    
    var numberActivePoints: Int {
        points.values.reduce(0,+)
    }
}

// Part 1
measure("Part 1") {
    // Three dimensional grid of strings
    let initial3DPlane = ThreeDimensionalPlane(points: initialInputPoints)
    var currentPlane = initial3DPlane
    for _ in 0..<6 {
        currentPlane = currentPlane.advance()
    }
    print(currentPlane.numberActivePoints)
}

struct HyperPoint: Equatable, Hashable {
    let x: Int
    let y: Int
    let z: Int
    let w: Int
    
    func point(from offset: HyperPoint) -> HyperPoint {
        return HyperPoint(x: x + offset.x, y: y + offset.y, z: z+offset.z, w: w+offset.w)
    }
}

var initialInputHyperPoints: [HyperPoint:Int] = [:]
initialInput.enumerated().forEach { row in
    row.element.enumerated().compactMap {
        initialInputHyperPoints[HyperPoint(x: $0.offset, y: row.offset, z:0, w:0)] = $0.element
    }
}

var hyperNeighborOffsets: [HyperPoint] = []
for possibleNeighborX in possibleNeighbors {
    for possibleNeighborY in possibleNeighbors {
        for possibleNeighborZ in possibleNeighbors {
            for possibleNeighborW in possibleNeighbors {
                if possibleNeighborX == possibleNeighborY,
                   possibleNeighborX == possibleNeighborZ,
                   possibleNeighborX == possibleNeighborW,
                   possibleNeighborX == 0 {
                    // 0,0,0,0 isn't a neighbor, it's us!
                    continue
                }
                hyperNeighborOffsets.append(HyperPoint(x: possibleNeighborX, y: possibleNeighborY, z: possibleNeighborZ, w: possibleNeighborW))
            }
        }
    }
}

struct FourDimensionalPlane {
    let hyperPoints: [HyperPoint:Int]
    
    func isActive(point: HyperPoint) -> Bool {
        return hyperPoints[point] == 1
    }
    
    func numberOfActiveNeighbors(at point: HyperPoint) -> Int {
        return hyperNeighborOffsets.reduce(0) { accumulator, neighborOffset in
            let offsetPoint = point.point(from: neighborOffset)
            return accumulator + (isActive(point: offsetPoint) ? 1 : 0)
        }
    }
    
    func pointsWithNeighbors() -> [HyperPoint:Int] {
        var newPoints = hyperPoints
        hyperPoints.forEach { point in
            hyperNeighborOffsets.forEach { offset in
                let offsetPoint = point.key.point(from: offset)
                if !newPoints.keys.contains(offsetPoint) {
                    newPoints[offsetPoint] = 0
                }
            }
        }
        return newPoints
    }
    
    func advance() -> FourDimensionalPlane {
        var newPoints = hyperPoints
        for (point, _) in pointsWithNeighbors() {
            let activeNeighbors = numberOfActiveNeighbors(at: point)
            let isCurrentlyActive = isActive(point: point)
            if isCurrentlyActive, activeNeighbors == 2 || activeNeighbors == 3 {
                newPoints[point] = 1
            } else if !isCurrentlyActive, activeNeighbors == 3 {
                newPoints[point] = 1
            } else {
                newPoints[point] = 0
            }
        }
        return FourDimensionalPlane(hyperPoints: newPoints)
    }
    
    var numberActivePoints: Int {
        hyperPoints.values.reduce(0,+)
    }
}

// Part 2
measure("Part 2") {
    let initialFourDimensionalPlane = FourDimensionalPlane(hyperPoints: initialInputHyperPoints)
    var currentPlane = initialFourDimensionalPlane
    for _ in 0..<6 {
        currentPlane = currentPlane.advance()
    }
    print(currentPlane.numberActivePoints)
}

