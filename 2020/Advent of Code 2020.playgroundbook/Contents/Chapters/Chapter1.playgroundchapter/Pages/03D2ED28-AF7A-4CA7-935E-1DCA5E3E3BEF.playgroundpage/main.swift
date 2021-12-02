// Day 11
let input = Day11Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap { Array($0) }

let numRows = input.count
let numColumns = input[0].count

func advanceDay(input: [[Character]]) -> [[Character]] {
    var output = input
    for row in 0..<numRows {
        for col in 0..<numColumns {
            let character = input[row][col]
            if (character == "L") {
                var shouldFlip = true
                if row > 0 {
                    if col > 0, input[row - 1][col - 1] == "#" {
                        shouldFlip = false
                    }
                    if input[row - 1][col] == "#" {
                        shouldFlip = false
                    }
                    if col < numColumns - 1, input[row - 1][col + 1] == "#" {
                        shouldFlip = false
                    }
                }
                if col > 0, input[row][col - 1] == "#" {
                    shouldFlip = false
                }
                if col < numColumns - 1, input[row][col + 1] == "#" {
                    shouldFlip = false
                }
                if row < numRows - 1 {
                    if col > 0, input[row + 1][col - 1] == "#" {
                        shouldFlip = false
                    }
                    if input[row + 1][col] == "#" {
                        shouldFlip = false
                    }
                    if col < numColumns - 1, input[row + 1][col + 1] == "#" {
                        shouldFlip = false
                    }
                }
                
                if shouldFlip {
                    output[row][col] = "#"
                }
            } else if character == "#" {
                var adjacentFilled = 0
                if row > 0 {
                    if col > 0, input[row - 1][col - 1] == "#" {
                        adjacentFilled += 1
                    }
                    if input[row - 1][col] == "#" {
                        adjacentFilled += 1
                    }
                    if col < numColumns - 1, input[row - 1][col + 1] == "#" {
                        adjacentFilled += 1
                    }
                }
                if col > 0, input[row][col - 1] == "#" {
                    adjacentFilled += 1
                }
                if col < numColumns - 1, input[row][col + 1] == "#" {
                    adjacentFilled += 1
                }
                if row < numRows - 1 {
                    if col > 0, input[row + 1][col - 1] == "#" {
                        adjacentFilled += 1
                    }
                    if input[row + 1][col] == "#" {
                        adjacentFilled += 1
                    }
                    if col < numColumns - 1, input[row + 1][col + 1] == "#" {
                        adjacentFilled += 1
                    }
                }
                if (adjacentFilled >= 4) {
                    output[row][col] = "L"
                }
            }
        }
    }
    return output
}

// Part 1
measure("Part 1") {
    var previousDay = input
    var nextDay = advanceDay(input: previousDay)
    while previousDay != nextDay {
        previousDay = nextDay
        nextDay = advanceDay(input: previousDay)
    }
    print(nextDay.reduce(0) { total, array in
        total + array.reduce(0) {
            $0 + ($1 == "#" ? 1 : 0)
        }
    })
}

func advanceDay2(input: [[Character]]) -> [[Character]] {
    var output = input
    for row in 0..<numRows {
        for col in 0..<numColumns {
            let character = input[row][col]
            if (character == "L") {
                var shouldFlip: Bool = true;
                
                // Top Left
                var newRow = row - 1
                var newCol = col - 1
                while newRow >= 0, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    
                    newRow += -1
                    newCol += -1
                }
                
                // Left
                newRow = row
                newCol = col - 1
                while newRow >= 0, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    newCol += -1
                }
                
                // Bottom Left
                newRow = row + 1
                newCol = col - 1
                while newRow < numRows, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    
                    newRow += 1
                    newCol += -1
                }
                
                // Top
                newRow = row - 1
                newCol = col
                while newRow >= 0, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    
                    newRow += -1
                }
                
                // Bottom
                newRow = row + 1
                newCol = col
                while newRow < numRows, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    newRow += 1
                }
                // Top Right
                newRow = row - 1
                newCol = col + 1
                while newRow >= 0, newCol < numColumns {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    
                    newRow += -1
                    newCol += 1
                }
                
                // Right
                newRow = row
                newCol = col + 1
                while newCol < numColumns {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    
                    newCol += 1
                }
                
                
                // Bottom Right
                newRow = row + 1
                newCol = col + 1
                while newRow < numRows, newCol < numColumns {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        shouldFlip = false
                        break
                    }
                    
                    newRow += 1
                    newCol += 1
                }
                
                if shouldFlip {
                    output[row][col] = "#"
                }
            } else if character == "#" {
                var adjacentFilled = 0
                // Top Left
                var newRow = row - 1
                var newCol = col - 1
                while newRow >= 0, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        adjacentFilled += 1
                        break
                    }
                    
                    newRow += -1
                    newCol += -1
                }
                
                // Left
                newRow = row
                newCol = col - 1
                while newRow >= 0, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {                        
                        adjacentFilled += 1
                        break
                    }
                    newCol += -1
                }
                
                // Bottom Left
                newRow = row + 1
                newCol = col - 1
                while newRow < numRows, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        adjacentFilled += 1
                        break
                    }
                    
                    newRow += 1
                    newCol += -1
                }
                
                // Top
                newRow = row - 1
                newCol = col
                while newRow >= 0, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        adjacentFilled += 1
                        break
                    }
                    
                    newRow += -1
                }
                
                // Bottom
                newRow = row + 1
                newCol = col
                while newRow < numRows, newCol >= 0 {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        adjacentFilled += 1
                        break
                    }
                    newRow += 1
                }
                // Top Right
                newRow = row - 1
                newCol = col + 1
                while newRow >= 0, newCol < numColumns {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        adjacentFilled += 1
                        break
                    }
                    
                    newRow += -1
                    newCol += 1
                }
                
                // Right
                newRow = row
                newCol = col + 1
                while newCol < numColumns {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        adjacentFilled += 1
                        break
                    }
                    
                    newCol += 1
                }
                
                
                // Bottom Right
                newRow = row + 1
                newCol = col + 1
                while newRow < numRows, newCol < numColumns {
                    let newCharacter = input[newRow][newCol]
                    if newCharacter == "L" {
                        break
                    }
                    if newCharacter == "#" {
                        adjacentFilled += 1
                        break
                    }
                    
                    newRow += 1
                    newCol += 1
                }
                
                if (adjacentFilled >= 5) {
                    output[row][col] = "L"
                }
            }
        }
    }
    return output
}

// Part 2
measure("Part 2") {
    var previousDay = input
    var nextDay = advanceDay2(input: previousDay)
    while previousDay != nextDay {
        previousDay = nextDay
        nextDay = advanceDay2(input: previousDay)
    }
    print(nextDay.reduce(0) { total, array in
        total + array.reduce(0) {
            $0 + ($1 == "#" ? 1 : 0)
        }
    })
}

