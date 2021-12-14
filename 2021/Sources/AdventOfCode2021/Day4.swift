//
// Copyright Mark A Vitale
//

public struct Day4: Day {
	func part1() -> String {
		let input = Day4Input.sample
		let splitInput = input.components(separatedBy: "\n\n")
		
		let numbers = splitInput[0].components(separatedBy: ",").compactMap { Int($0) }
		
		let cards = splitInput[1..<splitInput.count]
			.map {
				$0.split(separator: "\n").map {
					$0.split(separator: " ").map {
						Int($0)!
					}
				}
			}
		
		return ""
	}
	
	func part2() -> String {
		let input = Day4Input.sample
		
		return ""
	}
}
