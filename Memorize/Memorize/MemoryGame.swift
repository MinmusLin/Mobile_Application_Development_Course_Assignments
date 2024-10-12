//
// Project Name: Memorize
// File Name:    MemoryGame.swift
// Author:       Jishen Lin
// Update Date:  2024-10-13
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }

    func choose(_ card: Card){
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    struct Card {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
    }
}
