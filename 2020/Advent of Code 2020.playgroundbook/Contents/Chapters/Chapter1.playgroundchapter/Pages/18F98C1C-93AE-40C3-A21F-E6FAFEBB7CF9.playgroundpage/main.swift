// Day 5
let boardingPasses = Day5Input.components(separatedBy: "\n").flatMap {
    BoardingPass(boardingInfo: $0)
}

struct BoardingPass {
    let boardingInfo: String
    var row: Int {
        var max = 127
        var min = 0
        
        for character in boardingInfo {
            if character == "F" {
                max = max - ((max - min) / 2) - 1 
            } else if character == "B" {
                min = min + ((max - min) / 2) + 1
            } else {
                break
            }
        }
        
        if max == min {
            return max
        } else {
            return -1
        }
    }
    
    var column: Int {
        var max = 7
        var min = 0
        
        for character in boardingInfo {
            switch character {
            case "L":
                max = max - ((max - min) / 2) - 1 
            case "R":
                min = min + ((max - min) / 2) + 1
            default:
                continue
            }
        }
        if max == min {
            return max
        } else {
            return -1
        }
    }
    
    var seatID: Int {
        row * 8 + column
    }
}

// Part 1
measure("Part 1") {
    let maxSeatID = boardingPasses.reduce(-1) {
        max($0, $1.seatID)
    }
    print("Part 1 answer is \(maxSeatID)")
}

// Part 2
measure("Part 2") {
    let sortedIDs = boardingPasses.map {        
        $0.seatID
    }.sorted()
    
    var previousID = -1
    for id in sortedIDs {
        if id - previousID == 2 {
            print("Part 2 answer is \(id - 1)")
            break
        }
        previousID = id
    }
}

