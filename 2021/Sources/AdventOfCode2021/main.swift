//
// Copyright Mark A Vitale
//

import Foundation

func measure(_ title: String, block: () -> ()) {
	let startTime = CFAbsoluteTimeGetCurrent()
	
	block()
	
	let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
	let formattedTime = String(format: "%.3f", timeElapsed * 1000)
	print("\(title):: Time: \(formattedTime) ms")
}

let currentDay = Day13()

print("Solving for \(String(describing: type(of: currentDay.self)))")

print("")

measure("Part 1") {
	print("Part 1:: Solution: \(currentDay.part1())")
}

measure("Part 2") {
	print("Part 2:: Solution: \(currentDay.part2())")
}

print("")
