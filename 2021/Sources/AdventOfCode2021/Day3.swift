//
// Copyright Mark A Vitale
//

import Foundation

public struct Day3: Day {
	func part1() -> String {
		let input = Day3Input.real
		let codes = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
		let lengthOfCodes = codes.first?.count ?? 0
		
		let positionArrays = (0..<lengthOfCodes).map { index in
			codes.map { $0[$0.index($0.startIndex, offsetBy: index)] }
		}
		
		let positionReductions = positionArrays.map {
			$0.reduce(0) { result, next in
				result + (next == "1" ? 1 : 0)
			}
		}
		
		let codeTippingPoint = codes.count / 2
		
		let gamma = positionReductions.map {
			$0 > codeTippingPoint ? "1" : "0"
		}
		
		let epsilon = gamma.map {
			$0 == "1" ? "0" : "1"
		}
		
		print()
		
		return "\(binarytoDecimal(bitArray: gamma) * binarytoDecimal(bitArray: epsilon))"
	}
	
	func part2() -> String {
		let input = Day3Input.real
		let codes = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
		let lengthOfCodes = codes.first?.count ?? 0
				
		var filteredCodes = codes
		var offset = 0
		while offset < lengthOfCodes {
			let codeCount = filteredCodes.count
			
			let numberOfOnes = filteredCodes
				.map { $0[$0.index($0.startIndex, offsetBy: offset)] }
				.reduce(0) { $0 + ($1 == "1" ? 1 : 0) }
			
			let dominantValue = numberOfOnes >= (codeCount - numberOfOnes) ? "1" : "0"
			
			filteredCodes = filteredCodes.filter { code in
				let relevantValueIndex = code.index(code.startIndex, offsetBy: offset)
				return code[relevantValueIndex] == Character(dominantValue)
			}
			
			if filteredCodes.count == 1 {
				break
			}
			
			offset += 1
		}
		let oxygenGeneratorRating = binarytoDecimal(bitArray: filteredCodes.first!.map { String($0) })
		
		
		filteredCodes = codes
		offset = 0
		while offset < lengthOfCodes {
			let codeCount = filteredCodes.count
			
			let numberOfOnes = filteredCodes
				.map { $0[$0.index($0.startIndex, offsetBy: offset)] }
				.reduce(0) { $0 + ($1 == "1" ? 1 : 0) }
			
			let dominantValue = numberOfOnes < (codeCount - numberOfOnes) ? "1" : "0"
			
			filteredCodes = filteredCodes.filter { code in
				let relevantValueIndex = code.index(code.startIndex, offsetBy: offset)
				return code[relevantValueIndex] == Character(dominantValue)
			}
			
			if filteredCodes.count == 1 {
				break
			}
			
			offset += 1
		}
		let co2ScrubberRating = binarytoDecimal(bitArray: filteredCodes.first!.map { String($0) })


		return "\(oxygenGeneratorRating * co2ScrubberRating)"
	}
	
	func binarytoDecimal(bitArray: [String]) -> Int {
		bitArray.reversed().enumerated().reduce(0) { result, next in
			result + (next.element == "1"
					  ? 2 << (next.offset - 1)
					  : 0)
		}
	}
}
