// Day 19
let splitInput = Day19Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")

let rules = splitInput[0].components(separatedBy: "\n")
let messages = splitInput[1].components(separatedBy: "\n")

var splitRules: [Int:String] = [:]
rules.forEach { rule in
    let ruleComponents = rule.components(separatedBy: ": ")
    if let ruleNumber = Int(ruleComponents[0]) {
        splitRules[ruleNumber] = ruleComponents[1]
    } else {
        print("Parsing error")
    }
}

var simplifiedRules: [Int:Set<String>] = [:]
// Takes a rule, simplifies it down to its root values, and stores it in the simplifiedRules dict and returns it
func simplifyRule(initialRuleNumber: Int) -> Set<String> {
    guard !simplifiedRules.keys.contains(initialRuleNumber) else {
        return simplifiedRules[initialRuleNumber]!
    }
    
    guard let ruleValue = splitRules[initialRuleNumber] else {
        print("invalid rule \(initialRuleNumber)") 
        return Set(["*"])
    }
    
    var listOfRuleCombinations: [String]
    if ruleValue.contains("\"") {
        // A core value! Awesome.
        let valuesArray = ruleValue.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\"").compactMap { $0.isEmpty ? nil : $0 }
        simplifiedRules[initialRuleNumber] = Set(valuesArray)
        return Set(valuesArray)
    } else if ruleValue.contains("|") {
        listOfRuleCombinations = ruleValue.components(separatedBy: "|")
    } else {
        listOfRuleCombinations = [ruleValue]
    }
    
    var totalPatterns: Set<String> = Set()
    outerloop: for ruleCombination in listOfRuleCombinations {
        var setOfPatterns: Set<String> = Set()
        let ruleNumbersToFollow = ruleCombination.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").compactMap { Int($0) }
        for ruleNumber in ruleNumbersToFollow {
            let potentialSolutions = simplifyRule(initialRuleNumber: ruleNumber)
            if setOfPatterns.count == 0 {
                setOfPatterns = potentialSolutions
            } else {
                var newSet: Set<String> = Set()
                for pattern in setOfPatterns {
                    for solution in potentialSolutions {
                        newSet.insert(pattern + solution)
                    }
                }
                setOfPatterns = newSet
            }
        }
        totalPatterns = totalPatterns.union(setOfPatterns)
    }
    simplifiedRules[initialRuleNumber] = totalPatterns
    return totalPatterns
}

// Part 1
measure("Part 1") {
    simplifiedRules = [:]
    
    let ruleZeroPatterns = simplifyRule(initialRuleNumber: 0)
    let numberOfMatchingMessages = messages.reduce(0) {
        $0 + (ruleZeroPatterns.contains($1) ? 1 : 0)
    }
    print("Part 1 answer is \(numberOfMatchingMessages)")
}

// Part 2
measure("Part 2") {
    // Update 2 rules
    // 0 = 8 11
    splitRules[8] = "42 | 42 8"
    splitRules[11] = "42 31 | 42 11 31"
    
    // reset our simplified rules
    simplifiedRules = [:]
    
    let rule42Patterns = simplifyRule(initialRuleNumber: 42)
    let rule31Patterns = simplifyRule(initialRuleNumber: 31)
    
    let incrementSize = rule42Patterns.first!.count 
    
    messages.count
    
    // 2 42s
    // 1 31
    var numberOfMatchingMessages = 0
    messageLoop: for message in messages {
        var mutableMessage = message
        var numberOf42Matches = 0
        var numberOf31Matches = 0
        var lookingFor31 = false
        while mutableMessage.count >= incrementSize {
            if !lookingFor31 && rule42Patterns.contains(String(mutableMessage.prefix(incrementSize))) {
                numberOf42Matches += 1
                mutableMessage.removeFirst(incrementSize)
            } else if rule31Patterns.contains(String(mutableMessage.prefix(incrementSize))) {
                numberOf31Matches += 1
                lookingFor31 = true
                mutableMessage.removeFirst(incrementSize)
            } else {
                continue messageLoop
            }
        }
        if mutableMessage.count == 0 && numberOf42Matches >= 2 && numberOf42Matches > numberOf31Matches && numberOf31Matches >= 1  {
            numberOfMatchingMessages += 1
        }
    }
    
    print("Part 2 answer is \(numberOfMatchingMessages)")
}

