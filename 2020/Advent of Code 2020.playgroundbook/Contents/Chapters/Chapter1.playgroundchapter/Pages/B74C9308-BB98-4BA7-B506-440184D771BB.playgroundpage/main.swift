// Day 22
let decks = Day22Input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n").compactMap { $0.components(separatedBy: "\n").dropFirst().compactMap { Int($0) } }

// Part 1
measure("Part 1") {
    var player1Deck = decks[0]
    var player2Deck = decks[1]
    
    while player1Deck.count > 0 && player2Deck.count > 0 {
        let player1Card = player1Deck.removeFirst()
        let player2Card = player2Deck.removeFirst()
        if player1Card > player2Card {
            player1Deck.append(player1Card)
            player1Deck.append(player2Card)
        } else {
            player2Deck.append(player2Card)
            player2Deck.append(player1Card)
        }
    }
    
    let winningScore = player2Deck.reversed().enumerated().reduce(0) {
        $0 + ($1.offset + 1) * $1.element
    }
    
    print("Part 1 answer is: \(winningScore)")
}

struct DeckState: Hashable {
    let deck1: Int
    let deck2: Int
}

// Part 2
measure("Part 2") {
//      var cache: [DeckState:Bool] = [:]
    
    // return true for player1 win, false for player2 win
    func recursiveCombat(player1Deck: [Int], player2Deck: [Int]) -> (didPlayer1Win: Bool, winningDeck: [Int]) {
//          let initialDeckState = DeckState(deck1: player1Deck, deck2: player2Deck)
//          if let didPlayer1Win = cache[initialDeckState] {
//              return (didPlayer1Win, [])
//          }
            
        var player1Deck = player1Deck
        var player2Deck = player2Deck
        var playedHands: [DeckState] = []
        
        while player1Deck.count > 0 && player2Deck.count > 0 {
            // Check for infinite recursion
            let currentDeckState = DeckState(deck1: player1Deck.hashValue, deck2: player2Deck.hashValue)
            if playedHands.contains(currentDeckState) {
//                  cache[initialDeckState] = true
                return (true, player1Deck)
            } else {
                playedHands.append(currentDeckState)
            }
            
            let player1Card = player1Deck.removeFirst()
            let player2Card = player2Deck.removeFirst()
            
            var didPlayer1Win = false
            
            if player1Card <= player1Deck.count && 
               player2Card <= player2Deck.count {
                (didPlayer1Win, _) = recursiveCombat(player1Deck: Array(player1Deck[0..<player1Card]), player2Deck: Array(player2Deck[0..<player2Card]))
            } else {
                didPlayer1Win =  player1Card > player2Card
            }
            
            if didPlayer1Win {
                player1Deck.append(player1Card)
                player1Deck.append(player2Card)
            } else {
                player2Deck.append(player2Card)
                player2Deck.append(player1Card)
            }
        }
        
        let didPlayer1Win = player1Deck.count > 0
//          cache[initialDeckState] = didPlayer1Win
        return (didPlayer1Win, didPlayer1Win ? player1Deck : player2Deck)
    }
    
    let (didPlayer1Win, winningDeck) = recursiveCombat(player1Deck: decks[0], player2Deck: decks[1])
    
    let winningScore = winningDeck.reversed().enumerated().reduce(0) {
        $0 + ($1.offset + 1) * $1.element
    }
    print("Part 2 answer is: \(winningScore)")
}

