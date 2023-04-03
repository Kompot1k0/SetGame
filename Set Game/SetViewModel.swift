//
//  SetViewModel.swift
//  Set Game
//
//  Created by Admin on 07.03.2023.
//

import SwiftUI

class Set: ObservableObject {
    typealias Card = SetGame.Card
    
    @Published private var model = SetGame()
    
    var cards: [Card] {
        model.cards
    }
    
    var cardsToDisplay: [Card] {
        model.cardsToDisplay
    }
    
    var discardCards: [Card] {
        model.discardCards
    }
    
    func newGame() {
        model = SetGame()
    }
    
    func choose(_ card: Card) {
        model.chooseACard(card)
    }
    
    func addThreeCards() {
        model.addThreeCards()
    }
    
    func fillArray() {
        model.fillArray()
    }
}
