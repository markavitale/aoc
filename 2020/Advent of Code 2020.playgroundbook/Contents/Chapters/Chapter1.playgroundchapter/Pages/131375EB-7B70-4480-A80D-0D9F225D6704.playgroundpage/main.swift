// Day 9
let numbers = Day9Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").flatMap {
    Int($0)
}

let preambleLength = 25

// Part 1
measure("Part 1") {
    outerloop: for index in (preambleLength + 1)..<numbers.count {
        let targetNumber = numbers[index]
        let preamble = numbers[(index - preambleLength - 1)..<index]
        for number in preamble {
            if preamble.contains(targetNumber - number) {
                continue outerloop
            }
        }
        print("Part 1 answer is \(targetNumber)")
        break outerloop
    }
}

let targetSum = 14360655 // part 1 answer
// Part 2
measure("Part 2") {
    outerloop: for startIndex in 0..<numbers.count - 1 {
        var endIndex = startIndex + 1
        var sum = numbers[startIndex]
        while sum < targetSum {
            sum += numbers[endIndex]
            
            if sum == targetSum {
                let slice = numbers[startIndex...endIndex]
                print("Part 2 answer is \(slice.min()! + slice.max()!)")
                break outerloop
            }
            endIndex += 1
        }
    }
}

