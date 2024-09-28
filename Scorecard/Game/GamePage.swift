//
//  GamePage.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//

import SwiftUI
import SwiftData

struct GamePage: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var items: [Item]
    
    @State private var showingPlayers = false
    
    var currentItem = Item(frames: [Frame](), players: [Player]())
    
    init(selectedItem : Item){
        currentItem = selectedItem
    }
    init(itemIndex : Int){
        currentItem = items[itemIndex]
    }
    
    var body: some View {
        Button("Show Players"){
            showingPlayers = true
        }
        .popover(isPresented: $showingPlayers, content: {
            PlayerPage(selectedItem: currentItem)
        })
        FramePage(selectedItem: currentItem)
    }
}

#Preview {
    GamePage(itemIndex: 0)
}
