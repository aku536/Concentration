//
//  Concentration.swift
//  Concentration
//
//  Created by Кирилл Афонин on 10/01/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import Foundation

struct Concentration {
    // a deck of all cards
    private(set) var cards = [Card]()
    
    private(set) var points = 0
    private(set) var flipCount = 0
    private(set) var theEnd = false
    
    // themes and emojis
    private var emojiChoices = ["Halloween" : "🎃👻🦇👹👿🤯💀🐵",
                                "Winter" : "🏒🌨🎅🏻🥶☃❅🎄🎁",
                                "Sports" : "⚽️🏀⚾️🏈🥎🏐🎾🏉🎱",
                                "Music" : "🎤🎧🎼🎹🎸🎷🥁🎻🎺",
                                "Vehicles" : "🚗🚕🚎🚓🚑🚜🚒🏎🛵",
                                "Love" : "❤️💙💚💛🧡💜🖤💝💟",
                                ]
    // default theme key
    var themeKey = "Halloween"
    
    // at the game start deals the needed number of pairs, shuffles them and chose the theme
    init(numberOfPairsOfCards: Int) {
        //assert(numberOfPairsOfCards < 0, "Concentration.init(\(numberOfPairsOfCards)): there is no pairs")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
        
        var emojiChoicesKeys = Array(emojiChoices.keys)
        let randomIndex = Int(emojiChoicesKeys.count.arc4random)
        themeKey = emojiChoicesKeys[randomIndex]
    }
    
    private var emojiDictionary = [Card:String]()
    
    // picks an emoji randomly or return ??
    mutating func emoji(for card: Card) -> String {
        if emojiDictionary[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices[themeKey]!.index((emojiChoices[themeKey]?.startIndex)!, offsetBy: (emojiChoices[themeKey]?.count.arc4random)!)
            emojiDictionary[card] = String(emojiChoices[themeKey]!.remove(at: randomIndex))
        }
        return emojiDictionary[card] ?? "?"
    }
    
    // checks if only one card is faced up
    private var indexOfOneAndOnlyFaceUpCards: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    // flips the card and cheks matching
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCards(ar \(index): there is no such index")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCards, matchIndex != index {
                // check is card match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    points += 2
                    cards[matchIndex].wasFacedUp = false
                    cards[index].wasFacedUp = false
                    if cards.indices.filter({ cards[$0].isMatched }).count == cards.indices.count {
                        theEnd = true
                        cards[matchIndex].isFaceUp = false
                        cards[index].isFaceUp = false
                        return
                    }
                }
                cards[index].isFaceUp = true
                if cards[index].wasFacedUp {
                    points -= 1
                } else {
                    cards[index].wasFacedUp = true
                }
                if cards[matchIndex].wasFacedUp {
                    points -= 1
                } else {
                    cards[matchIndex].wasFacedUp = true
                }
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCards = index
            }
        }
    }
    
    mutating func resetGame() {
        points = 0
        flipCount = 0
        theEnd = false
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].wasFacedUp = false
        }
    }
}

// adds randomizer to Int
extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

// returns element if it is only one element in Collection
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
