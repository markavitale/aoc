// Day 2

struct PasswordInfo {
    let min: Int
    let max: Int
    let letter: String
    let password: String
    
    init(input: String) {
        let components = input.split(separator: " ")
        let numbers = components[0].split(separator: "-")
        min = Int(numbers[0])!
        max = Int(numbers[1])!
        letter = String(components[1].prefix(1))
        password = String(components[2]) 
    }
    
    func isValidPassword() -> Bool {
        let numberOfInstances = password.reduce(0) {
            $0 + (String($1) == letter ? 1 : 0)
        }
        return numberOfInstances >= min && numberOfInstances <= max
    }
    
    func isValidPasswordNewRules() -> Bool {
        let firstIndexMatch = String(password[password.index(password.startIndex, offsetBy: min-1)]) == letter
        let secondIndexMatch = String(password[password.index(password.startIndex, offsetBy: max-1)]) == letter
        return firstIndexMatch != secondIndexMatch
    }
}


let listofPasswordInfos = Day2Input.split(separator: "\n").map {
    PasswordInfo(input: String($0))
}

// Part 1
measure("Part 1") {
    let numberOfValidPasswords = listofPasswordInfos.reduce(0) { 
        $0 + ($1.isValidPassword() ? 1 : 0)
    }
    print("Part 1 answer: \(numberOfValidPasswords)")
}

// Part 2
measure("Part 2") {
    let numberOfValidPasswords = listofPasswordInfos.reduce(0) { 
        $0 + ($1.isValidPasswordNewRules() ? 1 : 0)
    }
    print("Part 2 answer: \(numberOfValidPasswords)")
}

