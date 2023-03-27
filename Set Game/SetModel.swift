//
//  SetModel.swift
//  Set Game
//
//  Created by Admin on 06.03.2023.
//

import Foundation
import SwiftUI

struct SetGame {
    
    struct Card: Identifiable {
        var isPressed = false
        var isSetCorrect = false
        var isSetWrong = false
        let content: CardContent
        let id: Int
    }
    
    private(set) var cards: [Card]
    private(set) var cardsToDisplay: [Card] = []
    
    private var counterOfMatchingSets: Int = 0
    private var counterOfNonMatchingSets: Int = 0
    private var counterOfPressedCards: Int = 0
    
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
        // filled array of cards to display
        withAnimation(.easeOut) {
            fillArray(with: cards)
        }
    }
    
    mutating func chooseACard(_ card: Card) {
        
        guard let chosenIndex = cardsToDisplay.firstIndex(where: { $0.id == card.id}) else {
            return
        }
        
        // If allready exist 3 sets of matching or nonMatching do what rules tell to do
        replaceMatchingSets()
        deselectNonMatchingSets()
        
        if !card.isSetCorrect && !card.isSetWrong {
            cardsToDisplay[chosenIndex].isPressed.toggle()
        }
        
        // if 3 card selected mark them as matched or nonMatched
        checkIfSetMatchedOrNonMatched()
    }
    
    private mutating func fillArray(with cards: [Card]) {
        var counter = 0
        if cards.count >= 12 {
            while cardsToDisplay.count < 12 {
                cardsToDisplay.insert(self.cards.removeFirst(), at: counter)
                counter += 1
            }
        }
    }
    
    mutating func addThreeCards() {
        guard !cards.isEmpty else { return }
        let numberOfCards = cardsToDisplay.count
        
        if counterOfMatchingSets > 0 {
            guard let indexes = getIndexOfFirstThreeSettedCards() else { return }
            for coun in 0..<3 {
                cardsToDisplay.remove(at: indexes[coun])
                cardsToDisplay.insert(self.cards.removeFirst(), at: indexes[coun])
            }
            counterOfMatchingSets -= 1
            return
        }
        
        if cardsToDisplay.count < 19 {
            while cardsToDisplay.count != numberOfCards + 3 {
                cardsToDisplay.append(cards.removeFirst())
            }
        }
    }
    
    private mutating func checkIfSetMatchedOrNonMatched() {
        guard let index = getIndexOfFirstThreePressedNonSettedCard()
        else { return }
        let indexOne = index[0]
        let indexTwo = index[1]
        let indexThree = index[2]
        
        var counterOfPressedCards: Int = 0
        for card in cardsToDisplay where card.isPressed &&
        !card.isSetCorrect && !card.isSetWrong {
            counterOfPressedCards += 1
        }
        guard counterOfPressedCards == 3 else {
            return
        }

        guard cardsToDisplay[indexOne].content.number ==
                cardsToDisplay[indexTwo].content.number &&
                cardsToDisplay[indexOne].content.number ==
            cardsToDisplay[indexThree].content.number ||
                cardsToDisplay[indexOne].content.number !=
                cardsToDisplay[indexTwo].content.number &&
                cardsToDisplay[indexOne].content.number !=
                cardsToDisplay[indexThree].content.number &&
                cardsToDisplay[indexTwo].content.number !=
                cardsToDisplay[indexThree].content.number
        else {
            cardsToDisplay[indexOne].isSetWrong = true
            cardsToDisplay[indexTwo].isSetWrong = true
            cardsToDisplay[indexThree].isSetWrong = true
            counterOfNonMatchingSets += 1
            return
        }

        guard cardsToDisplay[indexOne].content.shape ==
                cardsToDisplay[indexTwo].content.shape &&
                cardsToDisplay[indexOne].content.shape ==
            cardsToDisplay[indexThree].content.shape ||
                cardsToDisplay[indexOne].content.shape !=
                cardsToDisplay[indexTwo].content.shape &&
                cardsToDisplay[indexOne].content.shape !=
                cardsToDisplay[indexThree].content.shape &&
                cardsToDisplay[indexTwo].content.shape !=
                cardsToDisplay[indexThree].content.shape
        else {
            cardsToDisplay[indexOne].isSetWrong = true
            cardsToDisplay[indexTwo].isSetWrong = true
            cardsToDisplay[indexThree].isSetWrong = true
            counterOfNonMatchingSets += 1
            return
        }

        guard cardsToDisplay[indexOne].content.shading ==
                cardsToDisplay[indexTwo].content.shading &&
                cardsToDisplay[indexOne].content.shading ==
            cardsToDisplay[indexThree].content.shading ||
                cardsToDisplay[indexOne].content.shading !=
                cardsToDisplay[indexTwo].content.shading &&
                cardsToDisplay[indexOne].content.shading !=
                cardsToDisplay[indexThree].content.shading &&
                cardsToDisplay[indexTwo].content.shading !=
                cardsToDisplay[indexThree].content.shading
        else {
            cardsToDisplay[indexOne].isSetWrong = true
            cardsToDisplay[indexTwo].isSetWrong = true
            cardsToDisplay[indexThree].isSetWrong = true
            counterOfNonMatchingSets += 1
            return
        }

        guard cardsToDisplay[indexOne].content.color ==
                cardsToDisplay[indexTwo].content.color &&
                cardsToDisplay[indexOne].content.color ==
            cardsToDisplay[indexThree].content.color ||
                cardsToDisplay[indexOne].content.color !=
                cardsToDisplay[indexTwo].content.color &&
                cardsToDisplay[indexOne].content.color !=
                cardsToDisplay[indexThree].content.color &&
                cardsToDisplay[indexTwo].content.color !=
                cardsToDisplay[indexThree].content.color
        else {
            cardsToDisplay[indexOne].isSetWrong = true
            cardsToDisplay[indexTwo].isSetWrong = true
            cardsToDisplay[indexThree].isSetWrong = true
            counterOfNonMatchingSets += 1
            return
        }
        cardsToDisplay[indexOne].isSetCorrect = true
        cardsToDisplay[indexTwo].isSetCorrect = true
        cardsToDisplay[indexThree].isSetCorrect = true
        counterOfMatchingSets += 1
    }
    
    private mutating func replaceMatchingSets() {
        guard counterOfMatchingSets == 3 else { return }
        for card in cardsToDisplay where card.isSetCorrect {
            guard let cardIndex = cardsToDisplay.firstIndex(where: { $0.id == card.id })
            else { return }
            
            cardsToDisplay.removeAll(where: { $0.id == card.id })
            
            guard cards.isEmpty || cardsToDisplay.count > 11 else {
                cardsToDisplay.insert(cards.removeFirst(), at: cardIndex)
                continue
            }
        }
        counterOfMatchingSets = 0
    }
    
    private mutating func deselectNonMatchingSets() {
        guard counterOfNonMatchingSets == 3 else { return }
        for index in 0..<cardsToDisplay.count where cardsToDisplay[index].isSetWrong {
                cardsToDisplay[index].isSetWrong.toggle()
                cardsToDisplay[index].isPressed.toggle()
        }
        counterOfNonMatchingSets = 0
    }
    
    private func getIndexOfFirstThreeSettedCards() -> [Int]? {
        var index = [0, 0, 0]
        
        guard let indexOne = cardsToDisplay.firstIndex(where: { $0.isSetCorrect })
        else { return nil }
        guard let indexTwo = cardsToDisplay.firstIndex(where: { $0.isSetCorrect &&
            $0.id != cardsToDisplay[indexOne].id})
        else { return nil}
        guard let indexThree = cardsToDisplay.firstIndex(where: { $0.isSetCorrect &&
            $0.id != cardsToDisplay[indexOne].id &&
            $0.id != cardsToDisplay[indexTwo].id})
        else { return nil}
        
        index[0] = indexOne
        index[1] = indexTwo
        index[2] = indexThree
        
        return index
    }
    
    private func getIndexOfFirstThreePressedNonSettedCard() -> [Int]? {
        guard let indexOne = cardsToDisplay.firstIndex(where: {$0.isPressed &&
            !$0.isSetWrong &&
            !$0.isSetCorrect})
        else { return nil}
        guard let indexTwo = cardsToDisplay.firstIndex(where: {$0.isPressed &&
            !$0.isSetWrong &&
            !$0.isSetCorrect &&
            $0.id != cardsToDisplay[indexOne].id})
        else { return nil}
        guard let indexThree = cardsToDisplay.firstIndex(where: {$0.isPressed &&
            !$0.isSetWrong &&
            !$0.isSetCorrect &&
            $0.id != cardsToDisplay[indexOne].id &&
            $0.id != cardsToDisplay[indexTwo].id})
        else { return nil}
        
        let index = [indexOne, indexTwo, indexThree]
        return index
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
