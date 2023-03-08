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
            CardView(card: game.cards.first!)
            Text("Hello, world!")
        }
        .foregroundColor(.red)
        .padding()
    }
    
    struct CardView: View {
        let card: SetGame.Card
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                }
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 12 // used
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.55
        static let circlePadding: CGFloat = 6
        static let circleOpacity: CGFloat = 0.4
    }
}


















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = Set()
        SetContentView(game: game)
            .preferredColorScheme(.dark)
    }
}
