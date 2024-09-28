//
//  PlayerButton.swift
//  Scorecard
//
//  Created by Brett Garon on 9/19/24.
//

import SwiftUI

struct PlayerButton: View {
    var body: some View {
        Circle()
            .frame(width: 150, height: 150)
            .foregroundStyle(Color(red: 0.15, green: 0.5, blue: 0.41))
            .overlay{
                Text("Player List")
                    .font(.title)
                    .foregroundStyle(Color(red: 0.54, green: 0.69, blue: 0.79))
            }
    }
}

#Preview {
    PlayerButton()
}
