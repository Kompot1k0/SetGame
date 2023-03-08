//
//  SetModel.swift
//  Set Game
//
//  Created by Admin on 06.03.2023.
//

import Foundation

struct SetGame {
    
    struct Card {
        var isPressed = false
        var isSet = false
        let content: CardContent
        let id: Int
    }
    
    private(set) var cards: [Card]
    
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
//        cards = cards.shuffled()
        print("\(cards)")
    }
    
    func choose(_ card: Card) {
        
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
}
