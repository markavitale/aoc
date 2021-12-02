// Day 20
enum Edge {
    case top
    case bottom
    case left
    case right
    
    func flippedHorizontally() -> Edge {
        switch self {
        case .top,.bottom:
            return self
        case .left:
            return .right
        case .right:
            return .left
        }
    }
    
    func rotatedCounterClockwise() -> Edge {
        switch self {
        case .top:
            return .left
        case .bottom:
            return .right
        case .left:
            return .bottom
        case .right:
            return .top
        }
    }
}

struct Tile: Equatable {
    let identifier: Int
    let grid: [[Character]]
    let unmatchedEdges: [Edge]
    
    func flippedHorizontally() -> Tile {
        return Tile(identifier: identifier, 
                    grid: grid.map { $0.reversed() }, 
                    unmatchedEdges: unmatchedEdges.map { $0.flippedHorizontally() })
    }
    
    // counter-clockwise
    func rotatedCounterClockwise() -> Tile {
        let dimension = grid.count
        var rotatedGrid: [[Character]] = Array(repeating: Array(repeating:" ", count: dimension), count: dimension)
        grid.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, element) in
                rotatedGrid[dimension - 1 - columnIndex][rowIndex] = element
            }
        }
        
        return Tile(identifier: identifier, 
                    grid: rotatedGrid, 
                    unmatchedEdges: unmatchedEdges.map { $0.rotatedCounterClockwise() })
    }
    
    var description: String {
        let gridDescription = grid.reduce("") {
            "\($0)\n\($1)"
        }
        return "Tile \(identifier)\n\(gridDescription)"
    }

    func edge(_ edge: Edge) -> [Character] {
        switch edge {
        case .top:
            return grid[0]
        case .bottom:
            return grid[grid.count - 1]
        case .left:
            return grid.compactMap {$0[0]}
        case .right:
            return grid.compactMap {$0[$0.count - 1]}
        }
    }
    
    var edges: [[Character]] {
        return [edge(.top),edge(.bottom), edge(.left), edge(.right)]
    }
    
    func tileWithMatchingEdges() -> Tile {
        let otherTiles = tilesWithoutMatches.filter { identifier != $0.identifier }
        let otherTileEdges = otherTiles.flatMap { $0.edges }
        let unmatchedEdges = [Edge.top, Edge.bottom, Edge.left, Edge.right].filter { currentEdge in
            let edgeArray = edge(currentEdge)
            return !(otherTileEdges.contains(edgeArray) || otherTileEdges.contains(edgeArray.reversed()))
        }
        return Tile(identifier: identifier, grid: grid, unmatchedEdges: unmatchedEdges)
    }
}

let tilesWithoutMatches: [Tile] = Day20Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n").compactMap { tileDescription in
    let splitTileDescription = tileDescription.components(separatedBy: "\n")
    let identifier = Int(splitTileDescription[0].components(separatedBy: " ")[1].dropLast())!
    let grid = splitTileDescription.dropFirst().compactMap {
        Array($0)
    }
    return Tile(identifier: identifier, grid: grid, unmatchedEdges: [])
}

let tilesWithMatches = tilesWithoutMatches.compactMap { $0.tileWithMatchingEdges() }

func numberOfUnmatchedEdges(tile: Tile) -> Int {
    return tile.unmatchedEdges.count
}

// Part 1
measure("Part 1") {
    let cornerTiles = tilesWithMatches.filter { numberOfUnmatchedEdges(tile: $0) == 2 }
    let cornerTileIdentifierProduct = cornerTiles.reduce(1) { $0 * $1.identifier }
    
    print("Part 1 answer is: \(cornerTileIdentifierProduct)")
}

// Part 2
measure("Part 2") {
    var cornerTiles = tilesWithMatches.filter { numberOfUnmatchedEdges(tile: $0) == 2 }
    var edgeTiles = tilesWithMatches.filter { numberOfUnmatchedEdges(tile: $0) == 1 }
    var interiorTiles = tilesWithMatches.filter { numberOfUnmatchedEdges(tile: $0) == 0 }
    
    let edgeLength = 12
    let tileLength = cornerTiles.first!.grid.count
    
    var tileGrid: [[Tile?]] = Array(repeating: Array(repeating: nil, count: edgeLength), count: edgeLength)
    for rowIndex in 0..<edgeLength {
        for columnIndex in 0..<edgeLength {
            var unmatchedEdges: [Edge] = []
            var leftTile: Tile? = nil
            var topTile: Tile? = nil
            if rowIndex == 0 {
                unmatchedEdges.append(.top)
            } else {
                topTile = tileGrid[rowIndex - 1][columnIndex]!
                if rowIndex == edgeLength - 1 {
                    unmatchedEdges.append(.bottom)
                }
            }
            
            if columnIndex == 0 {
                unmatchedEdges.append(.left)
            } else {
                leftTile = tileGrid[rowIndex ][columnIndex - 1]!
                if columnIndex == edgeLength - 1 {
                    unmatchedEdges.append(.right)
                }
            }
            
            var tileForPlacement: Tile
            if let leftTile = leftTile, let topTile = topTile {
                var tile: Tile
                if unmatchedEdges.count == 0 {
                    var tileIndex = interiorTiles.firstIndex { tile in 
                        tile.edges.contains(topTile.edge(.bottom)) || tile.edges.contains(topTile.edge(.bottom).reversed())
                    }!
                    tile = interiorTiles[tileIndex]
                    interiorTiles.remove(at: tileIndex)
                } else if unmatchedEdges.count == 1 {
                    var tileIndex = edgeTiles.firstIndex { tile in 
                        tile.edges.contains(topTile.edge(.bottom)) || tile.edges.contains(topTile.edge(.bottom).reversed())
                    }!
                    tile = edgeTiles[tileIndex]
                    edgeTiles.remove(at: tileIndex)
                } else {
                    var tileIndex = cornerTiles.firstIndex { tile in 
                        tile.edges.contains(topTile.edge(.bottom)) || tile.edges.contains(topTile.edge(.bottom).reversed())
                    }!
                    tile = cornerTiles[tileIndex].rotatedCounterClockwise()
                    cornerTiles.remove(at: tileIndex)
                }
                
                var totalRotations = 0
                while topTile.edge(.bottom) != tile.edge(.top) || leftTile.edge(.right) != tile.edge(.left) || Set(tile.unmatchedEdges) != Set(unmatchedEdges) {
                    if totalRotations < 4 {
                        totalRotations += 1
                        tile = tile.rotatedCounterClockwise()
                    } else {
                        tile = tile.flippedHorizontally()
                        totalRotations = 0
                    }
                }
                tileForPlacement = tile
            } else if let leftTile = leftTile {
                var tile: Tile
                if unmatchedEdges.count == 1 {
                    var tileIndex = edgeTiles.firstIndex { tile in 
                        tile.edges.contains(leftTile.edge(.right)) || tile.edges.contains(leftTile.edge(.right).reversed())
                    }!
                    tile = edgeTiles[tileIndex]
                    edgeTiles.remove(at: tileIndex)
                } else {
                    var tileIndex = cornerTiles.firstIndex { tile in 
                        tile.edges.contains(leftTile.edge(.right)) || tile.edges.contains(leftTile.edge(.right).reversed())
                    }!
                    tile = cornerTiles[tileIndex]
                    cornerTiles.remove(at: tileIndex)
                }
                
                var totalRotations = 0
                while leftTile.edge(.right) != tile.edge(.left) || Set(tile.unmatchedEdges) != Set(unmatchedEdges) {
                    if totalRotations < 4 {
                        totalRotations += 1
                        tile = tile.rotatedCounterClockwise()
                    } else {
                        tile = tile.flippedHorizontally()
                        totalRotations = 0
                    }
                }
                tileForPlacement = tile
            } else if let topTile = topTile {
                var tile: Tile
                if unmatchedEdges.count == 1 {
                    var tileIndex = edgeTiles.firstIndex { tile in 
                        tile.edges.contains(topTile.edge(.bottom)) || tile.edges.contains(topTile.edge(.bottom).reversed())
                    }!
                    tile = edgeTiles[tileIndex]
                    edgeTiles.remove(at: tileIndex)
                } else {
                    var tileIndex = cornerTiles.firstIndex { tile in 
                        tile.edges.contains(topTile.edge(.bottom)) || tile.edges.contains(topTile.edge(.bottom).reversed())
                    }!
                    tile = cornerTiles[tileIndex]
                    cornerTiles.remove(at: tileIndex)
                }
                
                var totalRotations = 0
                while topTile.edge(.bottom) != tile.edge(.top) || Set(tile.unmatchedEdges) != Set(unmatchedEdges) {
                    if totalRotations < 4 {
                        totalRotations += 1
                        tile = tile.rotatedCounterClockwise()
                    } else {
                        tile = tile.flippedHorizontally()
                        totalRotations = 0
                    }
                }
                tileForPlacement = tile
            } else {
                var tile = cornerTiles.removeFirst()
                while Set(tile.unmatchedEdges) != Set(unmatchedEdges) {
                    if tile.unmatchedEdges.contains(.top) && unmatchedEdges.contains(.top) || tile.unmatchedEdges.contains(.bottom) && unmatchedEdges.contains(.bottom) {
                        tile = tile.flippedHorizontally()
                    } else {
                        tile = tile.rotatedCounterClockwise()
                    }
                }
                tileForPlacement = tile 
            }
            tileGrid[rowIndex][columnIndex] = tileForPlacement
        }
    }
    
    var combinedGrid: [[Character]] = Array(repeating: [], count: edgeLength * (tileLength - 2) )
    for rowIndex in 0..<tileGrid.count {
        for columnIndex in 0..<tileGrid[rowIndex].count {
            let tile = tileGrid[rowIndex][columnIndex]!
            for (index, row) in tile.grid[1..<tileLength-1].enumerated() {

                let trimmedInput = row[1..<tileLength-1]
                let oldArray = combinedGrid[rowIndex * (tileLength - 2) + index]
                
                combinedGrid[rowIndex * (tileLength - 2) + index] = oldArray + trimmedInput
            }
        }
    }
    
    let seaMonsterPattern = """
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
"""
    let seaMonsterGrid = seaMonsterPattern.trimmingCharacters(in: .newlines).components(separatedBy: "\n").compactMap { Array($0) }
    
    let seaMonsterHeight = seaMonsterGrid.count
    let seaMonsterLength = seaMonsterGrid[0].count
    
    
    var combinedGridForManipulation: [[Character]] = combinedGrid 
    
    
    var numberOfSeaMonsters = 0
    var totalRotations = 0
    var hasFlipped = false
    while numberOfSeaMonsters == 0 && totalRotations < 5 {
        var rotatedCombinedGrid: [[Character]] = Array(repeating: Array(repeating:" ", count: combinedGridForManipulation.count), count: combinedGridForManipulation.count)
        combinedGridForManipulation.enumerated().forEach { (rowIndex, row) in
            row.enumerated().forEach { (columnIndex, element) in
                rotatedCombinedGrid[combinedGridForManipulation.count - 1 - columnIndex][rowIndex] = element
            }
        }
        combinedGridForManipulation = rotatedCombinedGrid
        totalRotations += 1
        
        for rowIndex in 0..<combinedGridForManipulation.count - (seaMonsterHeight - 1)  {
            columnLoop: for columnIndex in 0..<rotatedCombinedGrid[rowIndex].count - (seaMonsterLength - 1) {
                seaMonsterLoop: for (seaMonsterRowIndex, row) in seaMonsterGrid.enumerated() {
                    for (seaMonsterColumnIndex, element) in row.enumerated() {
                        if element == "#" && rotatedCombinedGrid[rowIndex + seaMonsterRowIndex][columnIndex + seaMonsterColumnIndex] != "#" {
                            continue columnLoop
                        }
                    }
                }
                numberOfSeaMonsters += 1
            }
        }
        if !hasFlipped && totalRotations == 5 {
            totalRotations = 0
            hasFlipped = true
            combinedGridForManipulation = combinedGridForManipulation.map {
                $0.reversed()
            }
        }
    }
    print("Number Of Seamonsters: \(numberOfSeaMonsters)")
    
    let totalOctothorpes = combinedGridForManipulation.flatMap { $0 }.reduce(0) {
        $0 + ($1 == "#" ? 1 : 0) 
    }
    
    let seaMonsterOctothorpes = seaMonsterPattern.reduce(0) { $0 + ($1 == "#" ? 1 : 0) }
    
    var roughness = totalOctothorpes - numberOfSeaMonsters * seaMonsterOctothorpes
    print("Part 2 answer is: \(roughness)")
}
