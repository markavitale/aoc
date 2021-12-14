//
// Copyright Mark A Vitale
//

import CoreGraphics

public struct Day13: Day {
	struct Point: Hashable {
		let x: Int
		let y: Int
		
		func folded(by instruction: Instruction) -> Point {
			switch instruction.foldDirection {
				case .up:
					if y < instruction.line {
						return self
					} else {
						return Point(x: x, y: 2 * instruction.line - y)
					}
					
				case .left:
					if x < instruction.line {
						return self
					} else {
						return Point(x: 2 * instruction.line - x, y: y)
					}
			}
		}
	}
	
	struct Instruction {
		enum FoldDirection: String {
			case up = "y"
			case left = "x"
		}
		let foldDirection: FoldDirection
		let line: Int
	}
	
	func parsedInputs(from input: String) -> (coordinates: [Point], instructions: [Instruction]) {
		let dotCoordinates: [Point] = input
			.components(separatedBy: "\n\n")[0]
			.split(separator: "\n")
			.map { string in
				let numbers = string.split(separator:",")
				return Point(x: Int(numbers[0])!, y: Int(numbers[1])!)
			}
		let foldInstructions: [Instruction] = input
			.components(separatedBy: "\n\n")[1]
			.split(separator: "\n")
			.map { instruction in
				instruction.split(separator: " ")[2]
			}
			.map { instruction in
				let splitInstruction = instruction.split(separator: "=")
				return Instruction(
					foldDirection: Instruction.FoldDirection(rawValue: String(splitInstruction[0]))!,
					line: Int(splitInstruction[1])!
				)
			}
		
		return (dotCoordinates, foldInstructions)
	}
	
	func part1() -> String {
		let input = Day13Input.real
		let (dotCoordinates, foldInstructions) = parsedInputs(from: input)
		let foldedDotCoordinates = dotCoordinates.map { $0.folded(by: foldInstructions[0]) }
		
		return "\(Set(foldedDotCoordinates).count)"
	}
	
	func part2() -> String {
		let input = Day13Input.real

		let (dotCoordinates, foldInstructions) = parsedInputs(from: input)
				
		let foldedDotCoordinates = foldInstructions.reduce(dotCoordinates) { result, instruction in
			result.map { $0.folded(by: instruction) }
		}
		
		let grid = grid(from: foldedDotCoordinates)
		
		var resultString = "\n"
		grid.forEach {
			resultString += "\(String($0))\n"
		}
		
		return resultString
	}
	
	func largestPoint(of coordinates: [Point]) -> Point {
		return coordinates.reduce(Point(x: 0,y: 0)) { result, next in
			Point(x: max(result.x, next.x), y: max(result.y, next.y))
		}
	}

	func grid(from coordinates: [Point]) -> [[Character]] {
		let largestPoint = largestPoint(of: coordinates)
		let xArray: [Character] = Array(repeating: ".", count: largestPoint.x + 1)
		var grid = Array(repeating: xArray, count: largestPoint.y + 1)
		for point in coordinates {
			grid[point.y][point.x] = "#"
		}

		return grid
	}
}
