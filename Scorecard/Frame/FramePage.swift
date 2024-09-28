//
//  FramePage.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//

import SwiftUI
import SwiftData

struct FramePage: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var items: [Item]
    var currentItem : Item = Item()
    
    init(selectedItem : Item){
        self.currentItem = selectedItem
    }
    
    init(itemIndex : Int) {
        currentItem = items[itemIndex]
    }
    var body: some View {
        Text("FramePage")
        Button("Determine Winner", action: finalizeGame)
        Text(currentItem.winner)
        Text(currentItem.finalScoreString)
        NavigationSplitView{
            List{
                ForEach(currentItem.frames.sorted(by: >)){ frame in
                    NavigationLink(frame.holeNumber.description, destination: FrameInfo(selectedFrame: frame))
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addFrame) {
                        Label("Add Player", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        
    }
    
    private func finalizeGame(){
        var parScore = 0
        var frameParModifier : ModifierType
        
        var scores : [Player : Int] = [:]
        
        
        
        for player in currentItem.players {
            scores[player] = 0
        }
        
        
        for frame in currentItem.frames {
            
            frameParModifier = frame.modifiers.first(where: {$0.name == "par"})?.modifierType ?? .Arithmetic(value: 3)
            
            switch(frameParModifier){
                case .Arithmetic(let value) :
                    parScore += value
                default :
                    parScore += 3
            }
            
            
            
            for score in frame.scores {
                scores[score.player ?? Player()]! += score.score
            }
        }
        
        let winner = scores.max{a,b in a.value > b.value}
        currentItem.winner = winner?.key.name ?? ""
        
        var newWinnerString = ""
        var playerScore : Int? = nil
        var playerScoreString = ""
        
        for player in currentItem.players {
            
            playerScore = scores[player]
            
            playerScore = (playerScore ?? 0) - parScore
            
            playerScoreString = (scores[player]?.description ?? "")
            
            newWinnerString += player.name + "(" + playerScoreString + ") "
        }
        
        currentItem.finalScoreString = newWinnerString
        currentItem.isFinished = true
    }
    
    
    
    
    private func addFrame() {
        withAnimation {
            
            
            let newFrame = Frame(holeNumber: currentItem.frames.count+1)
            modelContext.insert(newFrame)
            
            newFrame.game = currentItem
            newFrame.players = currentItem.players
            var bufferScore : Score
            for player in newFrame.players {
                bufferScore = Score()
                modelContext.insert(bufferScore)
                bufferScore.player = player
                newFrame.scores.append(bufferScore)
            }
            
            currentItem.frames.append(newFrame)
            
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(currentItem.frames[index])
                currentItem.frames.remove(at: index)
            }
        }
    }
}

#Preview {
    FramePage(itemIndex: 0)
}
