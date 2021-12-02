// Day 15
let input = Day15Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",").compactMap { Int($0) }

// Part 1
measure("Part 1") {
    let numberOfTurns = 2020
    var numbers = input
    for index in 0..<(numberOfTurns-numbers.count) {
        let targetNumber = numbers.last!
        if let previousIndex = numbers.dropLast().lastIndex(of:targetNumber) {
            numbers.append(numbers.count - 1 - previousIndex)
        } else {
            numbers.append(0)
        }
    }
    print(numbers[numberOfTurns - 1])
}

// Part 2
measure("Part 2") {
    let numberOfTurns = 30000000
    var cache : [Int:Int] = [:]
    var targetNumber = 0
    for (index, number) in input.enumerated() {
        cache[number] = index
        targetNumber = number
    }
    cache.removeValue(forKey: targetNumber)
    
    for turnIndex in input.count..<numberOfTurns {
        if let oldValue = cache[targetNumber] {
            cache[targetNumber] = turnIndex - 1
            targetNumber = turnIndex - 1 - oldValue
        } else {
            cache[targetNumber] = turnIndex - 1
            targetNumber = 0
        }
    }
    print(targetNumber)
}

