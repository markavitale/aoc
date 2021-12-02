// Day 16
//  let rules = Day16Rules.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

// made this with regex find and replace in VS Code 
let rulesAsSets: [(ruleName: String, validSets: Set<Int>)] = [
    ("departure location", Set(47...164).union(179...960)),
    ("departure station", Set(49...808).union(833...968)),
    ("departure platform", Set(50...561).union(567...964)),
    ("departure track", Set(29...407).union(416...954)),
    ("departure date", Set(48...317).union(339...965)),
    ("departure time", Set(42...366).union(390...952)),
    ("arrival location", Set(45...292).union(304...974)),
    ("arrival station", Set(26...255).union(266...951)),
    ("arrival platform", Set(47...225).union(243...957)),
    ("arrival track", Set(37...442).union(452...954)),
    ("class", Set(35...120).union(127...958)),
    ("duration", Set(47...642).union(659...972)),
    ("price", Set(39...509).union(535...962)),
    ("route", Set(47...705).union(729...962)),
    ("row", Set(49...480).union(494...959)),
    ("seat", Set(28...846).union(865...969)),
    ("train", Set(30...598).union(606...968)),
    ("type", Set(42...905).union(924...965)),
    ("wagon", Set(29...884).union(899...973)),
    ("zone", Set(39...790).union(803...969)),
]

let myTicket = Day16MyTicket

let nearbyTickets = Day16NearbyTickets.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap {
    $0.components(separatedBy: ",").compactMap { number in Int(number) }
}

// Part 1
measure("Part 1") {
    let setOfValidNumbers = rulesAsSets.reduce(Set<Int>([])) {
        $0.union($1.validSets)
    }
    let ticketScanningErrorRate = nearbyTickets.reduce(0) {
        var invalidSum = 0
        for ticketValue in $1 {
            if !setOfValidNumbers.contains(ticketValue) {
                invalidSum += ticketValue
            }
        }
        return $0 + invalidSum
    }
    print("Part 1 answer is \(ticketScanningErrorRate)")
}

// Part 2
measure("Part 2") {
    // Get the rules as sets and reduce them into one big set
    let setOfValidNumbers = rulesAsSets.reduce(Set<Int>([])) {
        $0.union($1.validSets)
    }
    
    // Filter out to just valid tickets, include myTicket
    let validNearbyTickets = (nearbyTickets + [myTicket]).filter {
        var isValid = true
        for ticketValue in $0 {
            if !setOfValidNumbers.contains(ticketValue) {
                isValid = false
                break
            }
        }
        return isValid
    }
    
    // Turn the list of valid tickets into a set of all the values at each ticket index
    var potentialValues: [Int:Set<Int>] = [:]
    validNearbyTickets.forEach {
        for (index, value) in $0.enumerated() {
            if var oldSet = potentialValues[index] {
                oldSet.insert(value)
                potentialValues[index] = oldSet
            } else {
                potentialValues[index] = Set([value])
            }
        }
    }
    
    // A dict of ticket indexes -> potential rule names where everything matches 
    var ruleMappings: [Int:[String]] = [:] 
    ruleLoop: for rule in rulesAsSets {
        potentialValues.forEach { entry in
            if rule.validSets.isSuperset(of: entry.value) {
                if let oldMapping = ruleMappings[entry.key] {
                    ruleMappings[entry.key] = oldMapping + [rule.ruleName]
                } else {
                    ruleMappings[entry.key] = [rule.ruleName]
                }
            }
            
        }
    } 
    
    // Sort shortest first so we find rules closer to being "solved"
    let sortedMappings = ruleMappings.sorted {
        $0.value.count < $1.value.count
    }
    
    // Confirm one by one removing already confirmed mappings
    var confirmedMappings: [Int:String] = [:]
    sortedMappings.forEach { entry in
        print(entry)
        var possibleMappings = entry.value
        possibleMappings.removeAll {
            confirmedMappings.values.contains($0)
        }
        if possibleMappings.count == 1 {
            confirmedMappings[entry.key] = possibleMappings.first!
        }
    }
    
    // Multiply all the departure fields 
    // Could inline this in above loop but separating for cleanliness
    let departureProduct = confirmedMappings.reduce(1) {
        $0 * ($1.value.starts(with: "departure") ? myTicket[$1.key] : 1)
    }
    
    print("Part 2 answer is \(departureProduct)")
    
}
