//
//  PlayerRow.swift
//  Scorecard
//
//  Created by Brett Garon on 10/13/24.
//

import SwiftUI

struct PlayerRow: View {
    var player : Player
    init(player: Player) {
        self.player = player
    }
    var body: some View {
        ScorecardRectangle(text: player.name)
    }
}

#Preview {
    PlayerRow(player: Player())
}
