// Day 10

let inputJoltages = Day10Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap {
    Int($0)
}.sorted()

// Part 1
measure("Part 1") {
    // add the outlet
    let sorted = [0] + inputJoltages
    var byOne = 0
    var byThree = 0
    for index in 0..<sorted.count - 1 {
        let difference = sorted[index+1] - sorted[index]
        if difference == 3 {
            byThree += 1
        } else if difference == 1 {
            byOne += 1
        }
    }
    // Add one for the device
    print("Part 1 answer is: \(byOne * (byThree + 1))")
}

func calculateValidOptions(currentJoltage: Int, remainingJoltages: [Int]) -> [Int] {
    return remainingJoltages.filter {
        $0 > currentJoltage && $0 <= currentJoltage + 3
    }
}

var cache = Array(repeating: -1, count: inputJoltages.max()! + 5)
print(cache.count)
func numberOfOptions(joltages: [Int]) -> Int {
    let joltage = joltages.first!
    
    if cache[joltage] != -1 {
        return cache[joltage]
    }
    
    let newJoltages = Array(joltages.dropFirst())
    
    let validOptions = calculateValidOptions(currentJoltage: joltage, remainingJoltages: newJoltages)
    
    if validOptions.count == 0 {
        cache[joltage] = 1
        return 1
    }
    
    var total = 0
    var index = 0
    for option in validOptions {
        if cache[option] == -1 {
            let newList = Array(newJoltages.dropFirst(index))
            let value = numberOfOptions(joltages: newList)
            cache[option] = value
            total += value
        } else {
            total += cache[option]
        }
        index += 1
    }
    
    return total
}

// Part 2
measure("Part 2") {
    let joltagesWithAdapter = [0] + inputJoltages + [inputJoltages.max()! + 3]
    print("Part 2 answer is \(numberOfOptions(joltages: joltagesWithAdapter))")
}

