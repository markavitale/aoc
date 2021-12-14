//
// Copyright Mark A Vitale
//

public struct Day6: Day {
	func part1() -> String {
		let input = Day6Input.real
		let initialAges = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").compactMap { Int($0) }
		
		let finalAges = (0..<80).reduce(initialAges) { previousAges, _ in
			let numberOfNewFish = previousAges.filter { $0 == 0 }.count
			let newAges = previousAges.map { age -> Int in
				if age == 0 {
					return 6
				}
				return age - 1
			}
			return newAges + Array(repeating: 8, count: numberOfNewFish)
		}
		
			return "\(finalAges.count)"
	}
	
	func part2() -> String {
		let input = Day6Input.real
	
		let initialAges = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").compactMap { Int($0) }
		
		let ageDict = [
			0: 0,
			1: 0,
			2: 0,
			3: 0,
			4: 0,
			5: 0,
			6: 0,
			7: 0,
			8: 0
		]
		
		let initialAgeDict = initialAges.reduce(ageDict) { ageDict, initialAge in
			var ageDict = ageDict
			ageDict[initialAge] = ageDict[initialAge]! + 1
			return ageDict
		}
		
		let finalAges = (0..<256).reduce(initialAgeDict) { previousAgeDict, _ in
			var ageDict = previousAgeDict
			let numberOfNewFish = ageDict[0]!
			
			(1...8).forEach {
				ageDict[$0-1] = ageDict[$0]
			}
			
			ageDict[6] = ageDict[6]! + numberOfNewFish
			ageDict[8] = numberOfNewFish
			
			return ageDict
		}
		
		let totalFish = finalAges.values.reduce(0, +)
		
		return "\(totalFish)"
	}
}
