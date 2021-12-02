// Day 4
struct PassportInfo {
    let byr: Int?
    let iyr: Int?
    let eyr: Int?
    let hgt: String?
    let hcl: String?
    let ecl: String?
    let pid: String?
    let cid: String?
    
    var isValidForPart1: Bool {
        return byr != nil && iyr != nil && eyr != nil && hgt != nil && hcl != nil && ecl != nil && pid != nil
    }
    
    var isValidForPart2: Bool {
        guard let byr = byr, let iyr = iyr, let eyr = eyr, let hgt = hgt, let pid = pid, let ecl = ecl, let hcl = hcl else {
            return false
        }
        
        guard hgt.range(of: "([0-9]+)(in|cm)", options: .regularExpression) != nil else {
            return false
        }
        
        let heightNumber = Int(hgt.prefix(upTo: hgt.index(hgt.endIndex, offsetBy: -2)))!
        if hgt.hasSuffix("in") {
            guard heightNumber >= 59 && heightNumber <= 76 else {
                return false
            }
        } else if hgt.hasSuffix("cm") {
            guard heightNumber >= 150 && heightNumber <= 193 else {
                return false
            }
        }
        
        guard ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(ecl) else {
            return false
        }
        
        guard let range = pid.range(of: "[0-9]+", options: .regularExpression), pid[range].count == 9 else {
            return false
        }
        
        let hairString = hcl.suffix(from: hcl.index(after: hcl.startIndex))
        guard hcl.hasPrefix("#"), hairString.count == 6, hairString.allSatisfy({
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"].contains($0)
        }) else {
            return false
        }
        
        return isValidForPart1 &&
            (byr >= 1920 && byr <= 2002) &&
            (iyr >= 2010 && iyr <= 2020) &&
            (eyr >= 2020 && eyr <= 2030) 
            
    }
    
    init(input: String) {
        let pattern = "([a-zA-Z0-9#]+)"
        if let match = input.range(of: "byr:\(pattern)", options: .regularExpression) {
            byr = Int(input[match].components(separatedBy: "byr:")[1])
        } else {
            byr = nil
        }
        
        if let match = input.range(of: "iyr:\(pattern)", options: .regularExpression) {
            iyr = Int(input[match].components(separatedBy: "iyr:")[1])
        } else {
            iyr = nil
        }
        
        if let match = input.range(of: "eyr:\(pattern)", options: .regularExpression) {
            eyr = Int(input[match].components(separatedBy: "eyr:")[1])
        } else {
            eyr = nil
        }
        
        if let match = input.range(of: "hgt:\(pattern)", options: .regularExpression) {
            hgt = String(input[match].components(separatedBy: "hgt:")[1])
        } else {
            hgt = nil
        }
        
        if let match = input.range(of: "hcl:\(pattern)", options: .regularExpression) {
            hcl = String(input[match].components(separatedBy: "hcl:")[1])
        } else {
            hcl = nil
        }
        
        if let match = input.range(of: "ecl:\(pattern)", options: .regularExpression) {
            ecl = String(input[match].components(separatedBy: "ecl:")[1])
        } else {
            ecl = nil
        }
        
        if let match = input.range(of: "pid:\(pattern)", options: .regularExpression) {
            pid = String(input[match].components(separatedBy: "pid:")[1])
        } else {
            pid = nil
        }
        
        if let match = input.range(of: "cid:\(pattern)", options: .regularExpression) {
            cid = String(input[match].components(separatedBy: "cid:")[1])
        } else {
            cid = nil
        }
    }
    
}

let entries = Day4Input.replacingOccurrences(of: "\n\n", with: "<").split(separator: "<").map { String($0) }

let structEntries = entries.map {
    PassportInfo(input: $0)
}

// Part 1
measure("Part 1") {
    print(structEntries.reduce(0) {
        $0 + ($1.isValidForPart1 ? 1 : 0)
    })
}

// Part 2
measure("Part 2") {
    print(structEntries.reduce(0) {
        $0 + ($1.isValidForPart2 ? 1 : 0)
    })
}

