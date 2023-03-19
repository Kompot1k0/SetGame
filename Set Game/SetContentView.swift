//
//  ContentView.swift
//  Set Game
//
//  Created by Admin on 06.03.2023.
//

import SwiftUI

struct SetContentView: View {
    
    @ObservedObject var game: Set
    
    var body: some View {
        VStack {
            AspectVGrid(items: game.cardsToDisplay, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .padding(3)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            Text("\(game.cardsToDisplay.count)")
            Text("\(game.cards.count)")
            HStack {
                Button(action: game.newGame) {
                    Text("New Game")
                        .font(.title)
                        .foregroundColor(.blue)
                }.padding()
                Spacer()
                Button(action: game.addThreeCards) {
                    Text("Add 3 Cards")
                        .font(.title)
                        .foregroundColor(.blue)
                }.padding()
            }
        }
    }
    
    struct CardView: View {
        var card: SetGame.Card
        var body: some View {
            GeometryReader { proxy in
                let size = proxy.size
                    ZStack {
                        let number = defineNumber(card.content.number)
                        let shape = defineShape(card.content.shape, defineShading(card.content.shading))
                        let colorOfCard = defineColor(card.content.color)
                        let cardForm = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadiusForCard)
                        if card.isPressed {
                                cardForm.fill().foregroundColor(.black)
                                cardForm.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                                    .foregroundColor(defineBorderColor(card))
                        } else {
                            cardForm.fill().foregroundColor(.black)
                            cardForm.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                        }
                    VStack {
                        ForEach(0..<number, id: \.self) {_ in
                                shape
                                    .foregroundColor(colorOfCard)
                                    .frame(width: size.width * DrawingConstants.frameWidth, height: size.height * DrawingConstants.frameHeight)
                        }
                    }
                }
            }
        }
    } 
}

private func defineNumber(_ card: SetGame.CustomType) -> Int {
    switch card {
    case .first:
        return 1
    case .second:
        return 2
    case .third:
        return 3
    }
}

private func defineColor(_ card: SetGame.CustomType) -> Color {
    switch card {
    case .first:
        return Color.red
    case .second:
        return Color.orange
    case .third:
        return Color.blue
    }
}

@ViewBuilder private func defineShape(_ card: SetGame.CustomType, _ shading: CGFloat) -> some View {
        switch card {
        case .first:
            Rectangle().opacity(shading)
        case .second:
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadiusForShape)
                .opacity(shading)
        case .third:
            Diamond().opacity(shading)
        }
}

private func defineShading(_ card: SetGame.CustomType) -> CGFloat {
    switch card {
    case .first:
        return 0.1
    case .second:
        return 0.4
    case .third:
        return 1
    }
}

private func defineBorderColor(_ card: SetGame.Card) -> Color {
    if card.isSetCorrect {
        return .green
    } else if card.isSetWrong {
        return .red
    }
    return .yellow
}

private struct DrawingConstants {
    static let cornerRadiusForCard: CGFloat = 12 
    static let cornerRadiusForShape: CGFloat = 50
    static let lineWidth: CGFloat = 3
    static let frameWidth: CGFloat = 0.6
    static let frameHeight: CGFloat = 0.2
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = Set()
        SetContentView(game: game)
            .preferredColorScheme(.dark)
    }
}
