// Day 6
let families = Day6Input.components(separatedBy: "\n\n")
let alphabet = "abcdefghijklmnopqrstuvwxyz"


// Part 1
measure("Part 1") {
    let totalSum = families.reduce(0) { previousResult, family in
        let sum = alphabet.reduce(0) {
            $0 + (family.contains($1) ? 1 : 0)
        }
        return previousResult + sum 
    }
    print("Part 1 answer is \(totalSum)")
}

// Part 2
measure("Part 2") {
    let totalSum = families.reduce(0) { previousResult, family in
        let sum = alphabet.reduce(0) {
            for member in family.components(separatedBy: "\n") {
                if !member.contains($1) {
                    return $0
                }
            }
            
            return $0 + 1
        }
        return previousResult + sum 
    }
    print("Part 2 answer is \(totalSum)")

}

