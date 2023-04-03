//
//  Set_GameApp.swift
//  Set Game
//
//  Created by Admin on 06.03.2023.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = Set()
    var body: some Scene {
        WindowGroup {
            SetContentView(game: game)
        }
    }
}
