// Day 13
let input = Day13Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
let targetTimestamp = Int(input[0])!
let busRoutes = input[1].components(separatedBy: ",").compactMap { $0 }
let compactBusRoutes = input[1].components(separatedBy: ",").compactMap { Int($0) }

// Part 1
measure("Part 1") { 
    let result = compactBusRoutes.map { busId -> (Int, Int) in
        let busTimestamp = ((targetTimestamp / busId) + 1) * busId
        return (busId, busTimestamp - targetTimestamp)
    }
    let min = result.min {
        $0.1 < $1.1
    }
    print("Part 1 result is \(min!.0 * min!.1)") 
}

// Part 2
measure("Part 2") {
    let minimumAnswer = 100000000000000
    
    let compactMap: [(timestamp: Int, busId: Int)] = busRoutes.enumerated().compactMap { (index, busId) in
        guard let busId = Int(busId) else {
            return nil
        }
        return (Int(index), busId)
    }
    
    let proposedStartTimestamp = findAnswer(minimumAnswer: minimumAnswer, candidates:compactMap)
    print("Part 2 answer is \(proposedStartTimestamp)")
}

func findAnswer(minimumAnswer: Int, candidates: [(timestamp: Int, busId: Int)]) -> Int {
    let largestBusId = candidates.max {
        $0.busId < $1.busId
    }!
    var proposedStartTimestamp = ((minimumAnswer / largestBusId.busId) + 1) * largestBusId.busId - largestBusId.timestamp
    
    while true {
        let (isValid, matchedNumbers) = validateTimestamp(candidates: candidates, proposedTimestamp: proposedStartTimestamp)
        
        // check this before incrementing proposedStartTimestamp unless you're an idiot
        if isValid {
            break
        }
        
        proposedStartTimestamp += matchedNumbers.reduce(1,*)
    }
    return proposedStartTimestamp
}

func validateTimestamp(candidates: [(timestamp: Int, busId: Int)], proposedTimestamp: Int) -> (isValid: Bool, matchedNumbers: [Int]) {
    var isValid = true
    var matchedNumbers: [Int] = []
    for (timestamp, busId) in candidates {
        if (proposedTimestamp + timestamp) % busId != 0 {
            isValid = false
        } else {
            matchedNumbers.append(busId)
        }
    }
    return (isValid, matchedNumbers)
}

assert(findAnswer(minimumAnswer: 0, candidates: [(0, 17), (2, 13), (3, 19)]) == 3417)
assert(findAnswer(minimumAnswer: 0, candidates: [(0, 67), (1, 7), (2, 59), (3, 61)]) == 754018)

assert(validateTimestamp(candidates: [(0, 17), (2, 13), (3, 19)], proposedTimestamp: 3417).isValid)
assert(validateTimestamp(candidates: [(0, 67), (1, 7), (2, 59), (3, 61)], proposedTimestamp: 754018).isValid)


