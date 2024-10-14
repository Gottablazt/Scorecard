////
////  PlayerSelector.swift
////  Scorecard
////
////  Created by Brett Garon on 9/10/24.
////

import SwiftUI
import SwiftData

struct PlayerSelector: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var items : [Item]
    
    @Query private var players : [Player]
    
    @State var possiblePlayers : [Player]
    

    var newItem = Item()

    init(currentItem : Item){
        self.newItem = currentItem
        _possiblePlayers = State(initialValue: .init(repeating: Player(), count: 4))
    }
    
    var body: some View {
        Button{
            modelContext.insert(newItem)
            dismiss()
        } label: {
            Text("Finalize Game")
        }
        
        
    }
    
    
}

#Preview {
    PlayerSelector(currentItem: Item())
}
