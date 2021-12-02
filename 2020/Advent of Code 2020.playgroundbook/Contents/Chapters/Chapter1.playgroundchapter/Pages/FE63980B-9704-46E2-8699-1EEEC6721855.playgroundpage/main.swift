// Day 7

func populateDictionary(input: String) -> [String: [String: Int]] {
    var dictionary: [String: [String: Int]] = Dictionary()
    input.components(separatedBy: "\n").flatMap { ruleString in
        let ruleComponents = ruleString.components(separatedBy: "contain")
        let outerBag = String(ruleComponents[0].trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters).dropLast(5)) // remove " bags"
        
        var innerDictionary: [String: Int] = Dictionary()
        ruleComponents[1].components(separatedBy: ",").forEach {
            let description = $0.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters)
            
            if let number = Int(description.components(separatedBy: " ")[0]) {
                if description.hasSuffix(" bag") {
                    innerDictionary[String(description.dropFirst(2).dropLast(4))] = number
                } else {
                    innerDictionary[String(description.dropFirst(2).dropLast(5))] = number
                }
            }
        
        dictionary[outerBag] = innerDictionary
        }
    }
    return dictionary
}

let dictionary = populateDictionary(input: Day7Input)

func containsShinyGold(bagDescription:String) -> Bool {
    if let keys = dictionary[bagDescription]?.keys {
        if keys.contains("shiny gold") {
            return true
        }
        
        for key in keys {
            if containsShinyGold(bagDescription:key) {
                return true
            }
        }
    }
    
    return false
}

// Part 1
measure("Part 1") {
    let value: Int = dictionary.keys.reduce(0) {
        if containsShinyGold(bagDescription: $1) {
            return $0 + 1
        }else {
            return $0
        }
    }
    print("Part 1 answer: \(value)")
}

func numberOfContainedBags(bagDescription: String) -> Int {
    guard let keys = dictionary[bagDescription]?.keys else {
        return 0
    }
    var numberOfBags = 0
    for key in keys {
        numberOfBags += (1 + numberOfContainedBags(bagDescription: key)) * dictionary[bagDescription]![key]!
    }
    return numberOfBags
}

// Part 2
measure("Part 2") {
    print("Part 2 answer: \(numberOfContainedBags(bagDescription: "shiny gold"))")
}

