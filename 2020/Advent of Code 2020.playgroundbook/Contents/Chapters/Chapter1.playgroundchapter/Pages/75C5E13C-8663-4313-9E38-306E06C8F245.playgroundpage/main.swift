// Day 14
let commands = Day14Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

let sampleMask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"

assert(overrideWithMask(mask: sampleMask, memoryValue: 11) == 73)
assert(overrideWithMask(mask: sampleMask, memoryValue: 101) == 101)
assert(overrideWithMask(mask: sampleMask, memoryValue: 0) == 64)

func overrideWithMask(mask: String, memoryValue: UInt64) -> UInt64 {
    var intForAnding: UInt64 = 0
    var intForOring: UInt64 = 0
    for character in mask {
        intForOring = intForOring << 1
        intForAnding = intForAnding << 1
        if character == "0" {
            
        } else if character == "1" {
            intForAnding += 1
            intForOring += 1
        } else if character == "X" {
            intForAnding += 1
        }
    }
    
    return (memoryValue & intForAnding) | intForOring
}

// Part 1
measure("Part 1") {
    var memory: [Int : UInt64] = [:]
    var currentMask: Substring = ""
    for command in commands {
        if command.starts(with: "mask = ") {
            currentMask = command.dropFirst(7)
        } else if command.starts(with: "mem") {
            let addressRange = command.index(after: command.firstIndex(of: "[")!)..<command.firstIndex(of: "]")!
            let address = Int(command[addressRange])!
            
            let value = UInt64(command.components(separatedBy: " = ")[1])!
            memory[address] = overrideWithMask(mask: String(currentMask), memoryValue: value)
        }
    }
    print("Part 1 answer: \(memory.values.reduce(0, +))")
}

func overrideWithMemoryMask(mask: String, memoryAddress: UInt64) -> [UInt64] {
    var intsForMasking: [(intForOring: UInt64, intForAnding: UInt64)] = [(0,0)]
    for character in mask {
        for (index,ints) in intsForMasking.enumerated() {
            var newIntForOring = ints.intForOring << 1
            var newIntForAnding = ints.intForAnding << 1
            if character == "0" {
                newIntForAnding += 1
            } else if character == "1" {
                newIntForOring += 1
                newIntForAnding += 1
            } else if character == "X" {
                intsForMasking.append((newIntForOring,newIntForAnding))
                newIntForAnding += 1
                newIntForOring += 1
            }
            
            intsForMasking[index] = (newIntForOring, newIntForAnding)
        }
    }
    
    let addresses = intsForMasking.map {
        (memoryAddress | $0.intForOring) & $0.intForAnding
    }

    return addresses
}

// Part 2
measure("Part 2") {
    var memory: [UInt64 : UInt64] = [:]
    var currentMask: Substring = ""
    for command in commands {
        if command.starts(with: "mask = ") {
            currentMask = command.dropFirst(7)
        } else if command.starts(with: "mem") {
            let addressRange = command.index(after: command.firstIndex(of: "[")!)..<command.firstIndex(of: "]")!
            let address = UInt64(command[addressRange])!
            
            let value = UInt64(command.components(separatedBy: " = ")[1])!
            
            overrideWithMemoryMask(mask: String(currentMask), memoryAddress: address).forEach {
                memory[$0] = value
            }
        }
    }
    print("Part 2 answer: \(memory.values.reduce(0, +))")
}


