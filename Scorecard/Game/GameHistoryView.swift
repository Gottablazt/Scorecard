//
//  GameHistoryView.swift
//  Scorecard
//
//  Created by Brett Garon on 9/27/24.
//  MVP 0.0.1 10/3/24

import SwiftUI

struct GameHistoryView: View {
    
    
    
    @State var timestamp : String
    @State var scoreString : String
    @State var gameLengthString : String
    
    var selectedItem : Game
    
    init(selectedItem: Game) {
        
        self.selectedItem = selectedItem
        _timestamp = State(initialValue: selectedItem.timestamp.formatted(date: .abbreviated, time: .omitted))
        _scoreString = State(initialValue: selectedItem.finalScoreString)
        
        _gameLengthString = State(initialValue: "Game Length: " + selectedItem.frames.count.description + " Holes")
        
    }
    
    var body: some View {
        
        ZStack{
            
            Rectangle()
                .frame(width: 200, height: 100)
                .foregroundStyle(.secondary)
            
            VStack{
                
                Text(_timestamp.wrappedValue)
                Text(_scoreString.wrappedValue)
                Text(_gameLengthString.wrappedValue)
                
            }
            
        }
        
    }
    
}

#Preview {
    GameHistoryView(selectedItem: Game())
}
