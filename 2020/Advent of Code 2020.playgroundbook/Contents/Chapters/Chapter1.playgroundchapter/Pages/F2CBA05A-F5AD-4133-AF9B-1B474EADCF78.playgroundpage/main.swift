// Day 1
let inputs = Day1Input.split(separator: "\n")
let numberInputs = inputs.map {
    Int($0)!
}

// Part 1
measure("Part 1") {
    outerloop: for number in numberInputs {
        for number2 in numberInputs {
            if number + number2 == 2020 {
                print("Part 1 answer: \(number * number2)")
                break outerloop
            }
        }
    }
}

// Part 2
measure("Part 2") {
    outerloop: for number in numberInputs {
        for number2 in numberInputs {
            for number3 in numberInputs {
                if number + number2 + number3 == 2020 {
                    print("Part 2 answer: \(number * number2 * number3)")
                    break outerloop
                }
            }
        }
    }
}

