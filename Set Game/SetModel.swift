//
//  SetModel.swift
//  Set Game
//
//  Created by Admin on 06.03.2023.
//

import Foundation

struct SetGame {
    
    struct Card: Identifiable {
        var isPressed = false
        var isSet = false
        let content: CardContent
        let id: Int
    }
    
    private(set) var cards: [Card]
    private(set) var cardsToDisplay: [Card] = []
    
    init() {
        cards = []
        var index = 0
        
        for color in 0..<3 {
            for shape in 0..<3 {
                for number in 0..<3 {
                    for shading in 0..<3 {
                        let content = CardContent(color: CustomType(rawValue: color)!,
                                                    shape: CustomType(rawValue: shape)!,
                                                    number: CustomType(rawValue: number)!,
                                                    shading: CustomType(rawValue: shading)!)
                        cards.append(Card(content: content, id: index))
                        index += 1
                    }
                }
            }
        }
        cards = cards.shuffled()
        fillArray(with: cards)
    }
    
    func choose(_ card: Card) {
        
    }
    
    private mutating func fillArray(with cards: [Card]) {
        var counter = 0
        if cards.count >= 12 {
            while cardsToDisplay.count < 12 {
                cardsToDisplay.append(cards[counter])
                counter += 1
            }
        }
    }
    
    mutating func addThreeCards() {
        let numberOfCards = cardsToDisplay.count
        var index = 0
        
        if cardsToDisplay.count < 21 {
            while cardsToDisplay.count != numberOfCards + 3 {
                if !cardsToDisplay.contains(where: { $0.id == cards[index].id}) {
                    cardsToDisplay.append(cards[index])
                }
                index += 1
            }
        }
    }
    
    struct CardContent {
        let color: CustomType
        let shape: CustomType
        let number: CustomType
        let shading: CustomType
    }
    
    enum CustomType: Int {
        case first  = 0
        case second = 1
        case third  = 2
    }
    let test = CustomType.first
}
