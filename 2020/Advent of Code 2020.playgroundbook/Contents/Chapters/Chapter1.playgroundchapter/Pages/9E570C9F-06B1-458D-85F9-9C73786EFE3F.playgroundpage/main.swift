// Day 18
let equations = Day18Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

func simplifyEquation(equation: String, recursiveSolver: (String) -> Int) -> String {
    var simplifiedEquation = equation
    while simplifiedEquation.contains("(") {
        if let beginParenIndex = simplifiedEquation.firstIndex(of: "(") {
            var openParenCount = 1
            var endParenIndex = simplifiedEquation.endIndex
            for offset in (simplifiedEquation.distance(from: simplifiedEquation.startIndex,
                                                       to: beginParenIndex) + 1)..<simplifiedEquation.count {
                let newIndex = simplifiedEquation.index(simplifiedEquation.startIndex, offsetBy: offset)
                let value = simplifiedEquation[newIndex]
                let openParens = value 
                if value == "(" {
                    openParenCount += 1
                } else if value == ")" {
                    openParenCount += -1
                }
                if openParenCount == 0 {
                    endParenIndex = newIndex
                    break
                }
            }
            
            // Get the substring excluding the parens to calculate
            let proposedSubstring = simplifiedEquation[simplifiedEquation.index(after: beginParenIndex)...simplifiedEquation.index(before: endParenIndex)]
            
            let solvedParenEquation = recursiveSolver(String(proposedSubstring))
            
            simplifiedEquation.replaceSubrange(beginParenIndex...endParenIndex, with: String(solvedParenEquation))
        }
    }
    return simplifiedEquation
}

enum Operator {
    case add
    case multiply
    case unknown
}

func solve(equation: String) -> Int {
    let simplifiedEquation = simplifyEquation(equation: equation, recursiveSolver: solve)
    
    var result: Int? = nil
    var storedOperator = Operator.unknown
    for component in simplifiedEquation.components(separatedBy: " ") {
        if component == "+" {
            storedOperator = .add
        } else if component == "*" {
            storedOperator = .multiply
        } else if let value = Int(String(component)) {
            if let unwrappedResult = result {
                switch storedOperator {
                case .add:
                    result = unwrappedResult + value
                case .multiply:
                    result = unwrappedResult * value
                case .unknown:
                    print("Unknown action")
                }
                storedOperator = .unknown
            } else {
                result = value
            }
        }
    }
    
    return result ?? -1
}

// Part 1
measure("Part 1") {
    let sum = equations.reduce(0) {
        $0 + solve(equation: $1)
    }
    print("Part 1 answer is: \(sum)")
}

func solve2(equation: String) -> Int {
    let simplifiedEquation = simplifyEquation(equation: equation, recursiveSolver: solve2)
    
    var components: [String] = simplifiedEquation.components(separatedBy: " ")
    
    // + comes first
    while components.contains("+") {
        if let index = components.firstIndex(of: "+") {
            let sum = Int(components[index - 1])! + Int(components[index + 1])!
            components.replaceSubrange(index - 1...index + 1, with: [String(sum)])
        }
    }

    return components.reduce(1) {
        $0 * (Int($1) ?? 1)
    }
}

// Part 2
measure("Part 2") {
    let sum = equations.reduce(0) {
        $0 + solve2(equation: $1)
    }
    print("Part 2 answer is: \(sum)")
}

