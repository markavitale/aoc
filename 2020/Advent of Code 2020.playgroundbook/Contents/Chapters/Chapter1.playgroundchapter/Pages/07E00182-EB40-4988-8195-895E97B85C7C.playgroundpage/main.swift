// Day 8
enum OpCode: String {
    case acc = "acc"
    case jmp = "jmp"
    case nop = "nop"
}

struct Operation {
    let opCode: OpCode
    let value: Int
    
    init(opCode: OpCode, value: Int) {
        self.opCode = opCode
        self.value = value
    }
    
    init(string: String) {
        let components = string.components(separatedBy: " ")
        switch components[0] {
        case OpCode.acc.rawValue:
            opCode = .acc
        case OpCode.jmp.rawValue:
            opCode = .jmp
        case OpCode.nop.rawValue:
            opCode = .nop
        default:
            opCode = .nop
            
        }
        
        guard let value = Int(components[1]) else {
            print("Failure Parsing Operation")
            self.value = Int.max
            return;
        }
        self.value = value
    }
}

struct Program {
    let operations: [Operation]
    
    init(operations: [Operation]) {
        self.operations = operations
    }
    
    init(string: String) {
        operations = string.components(separatedBy: "\n").flatMap {
            Operation(string: $0)
        }
    }
    
    func runOnce() -> Int {
        guard operations.count > 0 else {
            return 0
        }
        
        var accumulator = 0
        var currentIndex = 0
        var visitedIndices: [Int] = []
        
        while !visitedIndices.contains(currentIndex) {
            visitedIndices.append(currentIndex)
            let operation = operations[currentIndex]
            switch operation.opCode {
            case .acc:
                accumulator += operation.value
                currentIndex += 1
            case .jmp:
                currentIndex += operation.value
            case .nop:
                currentIndex += 1
            }
        }
        return accumulator
    }
    
    func runAndDetermineTermination() -> (accumulator: Int, didTerminate: Bool) {
        guard operations.count > 0 else {
            return (0, true)
        }
        
        var accumulator = 0
        var currentIndex = 0
        var visitedIndices: [Int] = []
        
        while !visitedIndices.contains(currentIndex) {
            guard currentIndex < operations.count  else {
                return (accumulator, currentIndex == operations.count)
            }
            
            visitedIndices.append(currentIndex)
            let operation = operations[currentIndex]
            
            switch operation.opCode {
            case .acc:
                accumulator += operation.value
                currentIndex += 1
            case .jmp:
                currentIndex += operation.value
            case .nop:
                currentIndex += 1
            }
        }
        return (accumulator, false)
    }
    
    func swapJmpAndNop() -> [Program] {
        var newPrograms: [Program] = []
        for index in 0..<operations.count {
            if operations[index].opCode == .jmp {
                var operationsCopy = operations
                operationsCopy[index] = Operation(opCode: .nop, value: operations[index].value)
                newPrograms.append(Program(operations: operationsCopy))
            } else if operations[index].opCode == .nop {
                var operationsCopy = operations
                operationsCopy[index] = Operation(opCode: .jmp, value: operations[index].value)
                newPrograms.append(Program(operations: operationsCopy))
            }
        }
        return newPrograms
    }
}

// Part 1
measure("Part 1") {
    let program = Program(string: Day8Input)
    print("Part 1 answer is \(program.runOnce())")
}

// Part 2
measure("Part 2") {
    let program = Program(string: Day8Input)
    for swappedProgram in program.swapJmpAndNop() {
        let result = swappedProgram.runAndDetermineTermination()
        if result.didTerminate {
            print("Part 2 answer is \(result.accumulator)")
            break
        }
    }
}

