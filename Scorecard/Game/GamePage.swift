//
//  GamePage.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct GamePage: View {
    @Environment(\.modelContext) private var modelContext

    //fetch all games with an empty string descriptor
    static var fetchDescriptor: FetchDescriptor<Game> {
            let descriptor = FetchDescriptor<Game>(
                predicate: #Predicate { $0.descriptor == "" },
                sortBy: [
                    .init(\.timestamp)
                ]
            )
            return descriptor
        }
    
    @Query(GamePage.fetchDescriptor) private var items: [Game]
    
    
    @State private var showingScoreCard = false
    
    var currentItem = Game(frames: [Frame](), players: [Player]())
    
    init(selectedItem : Game){
        currentItem = selectedItem
    }
    
    init(itemIndex : Int){
        currentItem = items[itemIndex]
    }
    
    var body: some View {
        
        Button("Show ScoreCard"){
            showingScoreCard = true
        }.popover(isPresented: $showingScoreCard, content: {
            ScoreCardView(currentGame : currentItem)
        })
        
        FramePage(selectedItem: currentItem)
        
    }
    
}

#Preview {
    GamePage(itemIndex: 0)
}
