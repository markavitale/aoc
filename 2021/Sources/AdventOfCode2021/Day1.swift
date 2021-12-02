//
// Copyright Mark A Vitale
//

public struct Day1: Day {
	func part1() -> String {
		let input = Day1Input.real
		let depths = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").compactMap{ Int($0) }
		return String(numberOfIncreasingDepths(depths: depths, gapBetween: 1))
		
	}
	
	func part2() -> String {
		let input = Day1Input.real
		let depths = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").compactMap{ Int($0) }
		return "\(numberOfIncreasingDepths(depths: depths, gapBetween: 3))"
	}
	
	func numberOfIncreasingDepths(depths: [Int], gapBetween: Int) -> Int {
		let upperDepths = depths[gapBetween..<depths.count]
		return zip(depths, upperDepths).reduce(0) { (currentCount, depthPair) in
			currentCount + (depthPair.0 < depthPair.1 ? 1 : 0)
		}
	}
	
}
