// Day 3
let lines = Day3Input.split(separator: "\n")

let grid = lines.map {
    Array($0)
}

// Part 1
measure("Part 1") {
    var xPosition = 0
    var yPosition = 0
    var treeCount = 0
    
    while yPosition + 1 < grid.count {
        xPosition += 3
        yPosition += 1
        
        let line = grid[yPosition]
        let lineLength = line.count
        if line[xPosition % lineLength] == "#" {
            treeCount += 1
        }
        
    }
    print("Part 1 answer is \(treeCount)")
}

func checkSlope(deltaX: Int, deltaY: Int) -> Int {
    var xPosition = 0
    var yPosition = 0
    var treeCount = 0
    
    while yPosition + deltaY < grid.count {
        xPosition += deltaX
        yPosition += deltaY
        
        let line = grid[yPosition]
        let lineLength = line.count
        if line[xPosition % lineLength] == "#" {
            treeCount += 1
        }
        
    }
    return treeCount
}

// Part 2
measure("Part 2") {
    let answer = checkSlope(deltaX: 1, deltaY: 1) * checkSlope(deltaX: 3, deltaY: 1) * checkSlope(deltaX: 5, deltaY: 1) * checkSlope(deltaX: 7, deltaY: 1) * checkSlope(deltaX: 1, deltaY: 2)

    print("Part 2 answer is \(answer)")
    
}

