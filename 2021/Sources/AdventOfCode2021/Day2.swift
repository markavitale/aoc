//
// Copyright Mark A Vitale
//

public struct Day2: Day {
	
	enum Direction: String {
		case forward = "forward"
		case down = "down"
		case up = "up"
	}
	
	struct Command {
		let direction: Direction
		let magnitude: Int
	}
	
	struct SubmarinePosition {
		let horizontalPosition: Int
		let depth: Int
		let aim: Int
	}
	
	fileprivate func commandsFromInput(_ input: String) -> [Command] {
		return input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").map {
			let result = $0.split(separator: " ")
			return Command(direction: Direction(rawValue: String(result[0]))!, magnitude: Int(String(result[1]))!)
		}
	}
	
	func part1() -> String {
		let input = Day2Input.real
		
		let commands: [Command] = commandsFromInput(input)
		
		let finalSubPostion = commands.reduce(SubmarinePosition(horizontalPosition: 0, depth: 0, aim: 0 )) { previousPosition, command in
			
			return SubmarinePosition(
				horizontalPosition: previousPosition.horizontalPosition + (command.direction == .forward
																		   ? command.magnitude
																		   : 0),
				depth: previousPosition.depth + (command.direction == .down
												 ? command.magnitude
												 : 0) - (command.direction == .up
														 ? command.magnitude
														 : 0),
				aim: previousPosition.aim)
			
		}
		
		return "\(finalSubPostion.horizontalPosition * finalSubPostion.depth)"
	}
	
	func part2() -> String {
		let input = Day2Input.real
		
		let commands: [Command] = commandsFromInput(input)
		
		let finalSubPostion = commands.reduce(SubmarinePosition(horizontalPosition: 0, depth: 0, aim: 0 )) { previousPosition, command in
			
			return SubmarinePosition(
				horizontalPosition: previousPosition.horizontalPosition + (command.direction == .forward
																		   ? command.magnitude
																		   : 0),
				depth: previousPosition.depth + (command.direction == .forward
												 ? previousPosition.aim * command.magnitude
												 : 0),
				aim: previousPosition.aim  + (command.direction == .down
											  ? command.magnitude
											  : 0) - (command.direction == .up
													  ? command.magnitude
													  : 0))
		}
		
		return "\(finalSubPostion.horizontalPosition * finalSubPostion.depth)"
	}
	
}
