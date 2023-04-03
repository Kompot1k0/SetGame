//
//  ContentView.swift
//  Set Game
//
//  Created by Admin on 06.03.2023.
//

import SwiftUI

struct SetContentView: View {
    
    @ObservedObject var game: Set
    
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    
    var body: some View {
        VStack {
            gameBody
            HStack {
                ZStack {
                    deckBody
                    Text("+3 card's")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }.padding()
                Spacer()
                discardDeckBody
            }
            newGame
                .font(.title2)
                .foregroundColor(.blue)
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cardsToDisplay, aspectRatio: 2/3) { card in
            CardView(card: card, numberOfCards: game.cardsToDisplay.count)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                .padding(3)
                .onTapGesture {
                withAnimation {
                    game.choose(card)
                }
            }
        }.onAppear {
            for card in game.cards {
                guard game.cardsToDisplay.count != 12 else { return }
                withAnimation(dealAnimation(for: card)) {
                    game.fillArray()
                }
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards) { card in
                CardView(card: card, numberOfCards: game.cardsToDisplay.count)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            withAnimation {
                game.addThreeCards()
            }
        }
    }
    
    var discardDeckBody: some View {
        ZStack {
            ForEach(game.discardCards) { card in
                CardView(card: card, numberOfCards: game.cardsToDisplay.count)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    }
    
    var newGame: some View {
        Button("New Game") {
            game.newGame()
            for card in game.cards {
                guard game.cardsToDisplay.count != 12 else { return }
                withAnimation(dealAnimation(for: card)) {
                    game.fillArray()
                }
            }
        }
        .padding()
    }

    struct CardView: View {
        var card: SetGame.Card
        var numberOfCards: Int
        var body: some View {
            GeometryReader { proxy in
                let size = proxy.size
                let number = defineNumber(card.content.number)
                let shape = defineShape(card.content.shape, defineShading(card.content.shading))
                let colorOfCard = defineColor(card.content.color)
                VStack {
                    ForEach(0..<number, id: \.self) {_ in
                            shape
                                .opacity(!card.isUndealed ? 0 : 1)
                                .foregroundColor(colorOfCard)
                                .rotation3DEffect(Angle.degrees(card.isSetCorrect ? 180 : 0),
                                    axis: (1, 0, 0))
                                .animation(Animation.easeInOut(duration: 1).repeatCount(1),
                                           value: card.isSetCorrect)
                                    .frame(width: DrawingConstants.frameWidth,
                                           height: DrawingConstants.frameHeight)
                                    .scaleEffect(scale(thatFits: size, in: numberOfCards))
                    }.padding(.vertical, numberOfCards <= 12 ? 0 :
                                (numberOfCards <= 18 ? -3 : -5))

                }
                
                .cardify(isPressed: card.isPressed,
                          borderColor: defineBorderColor(card))
            }
        }
    }
    private func dealAnimation(for card: SetGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration /
            Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
}

private func scale(thatFits size: CGSize, in numberOfCards: Int) -> CGFloat {
    min(size.width, size.height) /
    (((DrawingConstants.frameWidth +
       DrawingConstants.frameHeight) / 2) /
     DrawingConstants.fontSize) / (numberOfCards <= 18 ? 1 : 1.1)
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
        return 0.2
    case .second:
        return 0.6
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
    static let frameWidth: CGFloat = 44
    static let frameHeight: CGFloat = 22
    static let fontSize: CGFloat = 0.4
}

private struct CardConstants {
    static let aspectRatio: CGFloat = 2/3
    static let dealDuration: Double = 0.4
    static let totalDealDuration: Double = 1.8
    static let undealtHeight: CGFloat = 110
    static let undealtWidth: CGFloat = undealtHeight * aspectRatio
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = Set()
        SetContentView(game: game)
            .preferredColorScheme(.dark)
    }
}
