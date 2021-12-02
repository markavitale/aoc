// Day 23
let cups = Day23Input.compactMap { Int(String($0)) }

//  func executeMove(cups: inout [Int], minCup: Int, maxCup: Int, currentCupIndex: Int) -> Int {
//      let currentCup = cups[currentCupIndex]
//      let pickedUpCups = cups[(currentCupIndex + 1)...(currentCupIndex + 3)]
//      cups.removeSubrange((currentCupIndex + 1)...(currentCupIndex + 3))
//      var targetNumber = currentCup - 1
//      while pickedUpCups.contains(targetNumber) || targetNumber < minCup {
//          targetNumber = targetNumber <= minCup ? maxCup : targetNumber - 1
//      }
//      guard let insertionIndex = cups.firstIndex(of: targetNumber) else {
//          print("Couldn't find target number \(targetNumber) in \(cups)")
//          return 0
//      }
//      let nextCupIndex: Int
//      if insertionIndex < currentCupIndex {
//          nextCupIndex = currentCupIndex + 4
//      } else {
//          nextCupIndex = currentCupIndex + 1
//      }
//      
//      cups.insert(contentsOf: pickedUpCups, at: insertionIndex + 1)
//      return nextCupIndex
//  }

class Node {
    var next: Node? = nil
    var value: Int? = nil
}

// Part 1
measure("Part 1") {
    let minCup = cups.min()!
    let maxCup = cups.max()!
    
    var nodeArray = Array(repeating: Node(), count: cups.count + 1)
    
    func executeMove(node: Node, minCup: Int, maxCup: Int) -> Node {
        guard let currentCupValue = node.value else { return Node() }

        let unusableTargets = [node.next!.value, node.next!.next!.value, node.next!.next!.next!.value]
        
        let oldNextNode = node.next!
        let newNextNode = node.next!.next!.next!.next!
        node.next = newNextNode
        
        var targetCupValue = currentCupValue - 1
        while targetCupValue < minCup || unusableTargets.contains(targetCupValue) {
            targetCupValue = targetCupValue <= minCup ? maxCup : targetCupValue - 1
        }
        let targetCup = nodeArray[targetCupValue]
        let targetCupOldNext = targetCup.next
        targetCup.next = oldNextNode
        oldNextNode.next!.next!.next = targetCupOldNext
        return newNextNode
    }
    
    var firstNode: Node? = nil
    var previousNode: Node? = nil
    cups.forEach {
        let node = Node()
        node.value = $0
        
        if let previousNode = previousNode {
            previousNode.next = node
        } else {
            firstNode = node
        }
        
        nodeArray[$0] = node
        previousNode = node
    }
    previousNode?.next = firstNode
    
    
    var currentHeadNode = firstNode!
    (0..<100).forEach { _ in
        currentHeadNode = executeMove(node: currentHeadNode, minCup: minCup, maxCup: maxCup)
    }
    
    let nodeOfOne = nodeArray[1]
    var node = nodeArray[1].next!
    var resultString = ""
    while node.value != nodeArray[1].value {
        resultString += String(node.value!)
        node = node.next!
    }
    print("Part 1 answer is: \(resultString)")
}

// Part 2
measure("Part 2") {
    var paddedCups = cups + ((cups.max()! + 1)...1000000)
    let minCup = paddedCups.min()!
    let maxCup = paddedCups.max()!
    var nodeArray = Array(repeating: Node(), count: paddedCups.count + 1)
    
    func executeMove(node: Node, minCup: Int, maxCup: Int) -> Node {
        guard let currentCupValue = node.value else { return Node() }
        
        let unusableTargets = [node.next!.value, node.next!.next!.value, node.next!.next!.next!.value]
        
        let oldNextNode = node.next!
        let newNextNode = node.next!.next!.next!.next!
        node.next = newNextNode
        
        var targetCupValue = currentCupValue - 1
        while targetCupValue < minCup || unusableTargets.contains(targetCupValue) {
            targetCupValue = targetCupValue <= minCup ? maxCup : targetCupValue - 1
        }
        let targetCup = nodeArray[targetCupValue]
        let targetCupOldNext = targetCup.next
        targetCup.next = oldNextNode
        oldNextNode.next!.next!.next = targetCupOldNext
        return newNextNode
    }
    
    var firstNode: Node? = nil
    var previousNode: Node? = nil
    paddedCups.forEach {
        let node = Node()
        node.value = $0
        
        if let previousNode = previousNode {
            previousNode.next = node
        } else {
            firstNode = node
        }
        
        nodeArray[$0] = node
        previousNode = node
    }
    previousNode?.next = firstNode
    
    
    var currentHeadNode = firstNode!
    (0..<10000000).forEach { _ in
        currentHeadNode = executeMove(node: currentHeadNode, minCup: minCup, maxCup: maxCup)
    }
    
    let resultProduct = nodeArray[1].next!.value! * nodeArray[1].next!.next!.value!
    print("Part 2 answer is: \(resultProduct)")
}

