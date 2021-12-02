// Day 25
let input = Day25Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap { Int($0) }

// Part 1
measure("Part 1") {
    var publicKeys = Array<Int>()
    
    var loopSize = 0
    var publicKey = 1
    
    var firstKeyLoopSize: Int? = nil
    var secondKeyLoopSize: Int? = nil
    
    while firstKeyLoopSize == nil || secondKeyLoopSize == nil {
        loopSize += 1
        publicKey = (publicKey * 7) % 20201227
        if publicKey == input[0] {
            firstKeyLoopSize = loopSize
        } else if publicKey == input[1] {
            secondKeyLoopSize = loopSize
        }
    }
    
    guard let finalizedFirstKeyLoopSize = firstKeyLoopSize else {
        return
    }
    
    guard let finalizedSecondKeyLoopSize = secondKeyLoopSize else {
        return
    }
    
    let encryptionKeyFromFirstKey = (0..<finalizedFirstKeyLoopSize).reduce(1) { runningTotal, _ in
        (runningTotal * input[1]) % 20201227
    }
    
    let encryptionKeyFromSecondKey = (0..<finalizedSecondKeyLoopSize).reduce(1) { runningTotal, _ in
        (runningTotal * input[0]) % 20201227
    }
    
    assert(encryptionKeyFromFirstKey == encryptionKeyFromSecondKey)
    print("Part 1 answer is: \(encryptionKeyFromFirstKey)")
}

// Part 2
measure("Part 2") {
    var publicKeys = Array<Int>()
    
    var loopSize = 0
    var publicKey = 1
    
    var oppositePublicKey: Int? = nil
    
    while oppositePublicKey == nil {
        loopSize += 1
        publicKey = (publicKey * 7) % 20201227
        if publicKey == input[0] {
            oppositePublicKey = input[1]
        } else if publicKey == input[1] {
            oppositePublicKey = input[0]
        }
    }
    
    let encryptionKey = (0..<loopSize).reduce(1) { runningTotal, _ in
        (runningTotal * oppositePublicKey!) % 20201227
    }
    
    print("Part 2 answer is: \(encryptionKey)")
}

