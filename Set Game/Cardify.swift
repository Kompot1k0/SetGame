//
//  Cardify.swift
//  Set Game
//
//  Created by Admin on 27.03.2023.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isPressed: Bool
    let borderColor: Color
    func body(content: Content) -> some View {
        let cardForm = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadiusForCard)
            ZStack {
            if isPressed {
                    cardForm.fill().foregroundColor(.black)
                    cardForm.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                        .foregroundColor(borderColor)
            } else {
                cardForm.fill().foregroundColor(.black)
                cardForm.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }
            content
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadiusForCard: CGFloat = 12
        static let cornerRadiusForShape: CGFloat = 50
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isPressed: Bool, borderColor: Color) -> some View {
        self.modifier(Cardify(isPressed: isPressed, borderColor: borderColor))
    }
}
