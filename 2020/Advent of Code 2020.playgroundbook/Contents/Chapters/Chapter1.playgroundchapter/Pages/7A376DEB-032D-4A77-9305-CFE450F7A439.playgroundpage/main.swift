// Day 12
enum Direction: Int {
    case north = 0
    case east = 1
    case south = 2
    case west = 3
}

struct ShipState {
    let northPosition: Int
    let eastPosition: Int
    let direction: Direction
    
    func rotate(left: Bool, degrees: Int) -> ShipState {
        var newDirection = direction
        let numberOfTurns = degrees / 90
        
        if left {
            newDirection = Direction(rawValue: (direction.rawValue + 4 - numberOfTurns) % 4)!
        } else {
            newDirection = Direction(rawValue: (direction.rawValue + numberOfTurns) % 4)!
        }
        
        return ShipState(northPosition: northPosition, eastPosition: eastPosition, direction: newDirection)
    }
    
    func move(direction: Direction, magnitude: Int) -> ShipState {
        var northPosition = self.northPosition
        var eastPosition = self.eastPosition
        switch direction {
        case .north:
            northPosition += magnitude
        case .south:
            northPosition += -magnitude
        case .east:
            eastPosition += magnitude
        case .west:
            eastPosition += -magnitude
        }
        return ShipState(northPosition: northPosition, eastPosition: eastPosition, direction: self.direction)
    }
    
    func moveForward(magnitude: Int) -> ShipState {
        return move(direction: direction, magnitude: magnitude)
    }
    
    var manhattanDistance : Int {
        return abs(northPosition) + abs(eastPosition)
    }
}

// Part 1
measure("Part 1") {
    let commands = Day12Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
    
    let finalState = commands.reduce(ShipState(northPosition: 0, eastPosition: 0, direction: .east)) {
        let command = $1.first
        let magnitude = Int($1.dropFirst())!
        var nextState: ShipState? = nil
        if command == "N" {
            nextState = $0.move(direction: .north, magnitude: magnitude)
        } else if command == "S" {
            nextState = $0.move(direction: .south, magnitude: magnitude)
        } else if command == "E" {
            nextState = $0.move(direction: .east, magnitude: magnitude)
        } else if command == "W" {
            nextState = $0.move(direction: .west, magnitude: magnitude)
        } else if command == "L" {
            nextState = $0.rotate(left: true, degrees: magnitude)
        } else if command == "R" {
            nextState = $0.rotate(left: false, degrees: magnitude)
        } else if command == "F" {
            nextState = $0.moveForward(magnitude: magnitude)
        }
        return nextState!
    }
    print("Part 1 answer: \(finalState.manhattanDistance)")
}


struct WaypointShipState {
    let northPosition: Int
    let eastPosition: Int
    let waypointNorth: Int
    let waypointEast: Int
    
    func rotate(left: Bool, degrees: Int) -> WaypointShipState {
        let numberOfTurns = degrees / 90
        
        var waypointEast = self.waypointEast, waypointNorth = self.waypointNorth
        for _ in 0..<numberOfTurns {
            if left {
                let tempEast = waypointEast
                waypointEast = -waypointNorth
                waypointNorth = tempEast
            } else {
                let tempEast = waypointEast
                waypointEast = waypointNorth
                waypointNorth = -tempEast
            }
        }
        
        return WaypointShipState(northPosition: northPosition, eastPosition: eastPosition, waypointNorth: waypointNorth, waypointEast: waypointEast)
    }
    
    func move(direction: Direction, magnitude: Int) -> WaypointShipState {
        var waypointNorth = self.waypointNorth
        var waypointEast = self.waypointEast
        switch direction {
        case .north:
            waypointNorth += magnitude
        case .south:
            waypointNorth += -magnitude
        case .east:
            waypointEast += magnitude
        case .west:
            waypointEast += -magnitude
        }
        return WaypointShipState(northPosition: northPosition, eastPosition: eastPosition, waypointNorth: waypointNorth, waypointEast: waypointEast)
    }
    
    func moveForward(magnitude: Int) -> WaypointShipState {
        return WaypointShipState(northPosition: northPosition + waypointNorth * magnitude, eastPosition: eastPosition + waypointEast * magnitude, waypointNorth: waypointNorth, waypointEast: waypointEast)
    }
    
    var manhattanDistance : Int {
        return abs(northPosition) + abs(eastPosition)
    }
}

// Part 2
measure("Part 2") {
    let commands = Day12Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
    
    let finalState = commands.reduce(WaypointShipState(northPosition: 0, eastPosition: 0, waypointNorth: 1, waypointEast: 10)) {
        let command = $1.first
        let magnitude = Int($1.dropFirst())!
        var nextState: WaypointShipState? = nil
        if command == "N" {
            nextState = $0.move(direction: .north, magnitude: magnitude)
        } else if command == "S" {
            nextState = $0.move(direction: .south, magnitude: magnitude)
        } else if command == "E" {
            nextState = $0.move(direction: .east, magnitude: magnitude)
        } else if command == "W" {
            nextState = $0.move(direction: .west, magnitude: magnitude)
        } else if command == "L" {
            nextState = $0.rotate(left: true, degrees: magnitude)
        } else if command == "R" {
            nextState = $0.rotate(left: false, degrees: magnitude)
        } else if command == "F" {
            nextState = $0.moveForward(magnitude: magnitude)
        }
        return nextState!
    }
    print("Part 2 answer: \(finalState.manhattanDistance)")
}

