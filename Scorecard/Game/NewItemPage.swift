//
//  NewItemPage.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//

import SwiftUI
import SwiftData



struct NewItemPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var items : [Item]
    
    @Query private var potentialPlayers : [Player]
    
    
    @State var players : [Player]
    
    @State var framecount : Int
    @State var playerCount : Int
    
    let newItem = Item()
    
    
    let playerCountOptions = [0,1,2,3,4]
    let holeOptions = [0,1, 3, 6, 9,18]
    
    @State var isShowingPlayerSelector = false
    @State var isSaved = false
    init(){
        _players = State(initialValue: [])
        _framecount = State(initialValue: 0)
        _playerCount = State(initialValue: 0)
        
       
    }
    
    
    var body: some View {
        VStack{
            HStack{
                Button("Cancel"){
                    dismiss()
                }
                
                Button("Done"){
                    saveInfo()
                    dismiss()
                }
            }
            Text("Number of Holes To Play")
            Picker(selection: $framecount, label: Text("Select the number of frames you would like to play")){
                ForEach(holeOptions, id: \.self){
                    hole in Text("\(hole)").tag(hole)
                }
            }
            Text("Number of Players in Game")
            Picker(selection: $playerCount, label: Text("Select the number of Players")){
                ForEach(playerCountOptions, id: \.self){
                    player in Text("\(player)").tag(player)
                }
            }
            
            
            Button(action: selectPlayers){
                Text("Select Players")
            }.sheet(isPresented: $isShowingPlayerSelector){
                PlayerSelector(currentItem : newItem)
            }

        }
    }
//    
    private func selectPlayers(){
        saveInfo()
        isShowingPlayerSelector = true
        
    }
    
    private func saveInfo(){
        
        if(isSaved){
            return
        }
        
        isSaved = true
        var iterator = potentialPlayers.makeIterator()
        
        //Create new Item
        modelContext.insert(newItem)
        
        if(newItem.players.isEmpty){
            
            //create var to store plyer objects in
            var bufferPlayer : Player
            
            //get existing player objects or create new ones to fill out the player list for the game
            for _ in 0..<playerCount{
                
                //decide to take an existing player or create a new one depending on if there is an existing player
                bufferPlayer = iterator.next() ?? Player(games: [])
                
                //save new player
                modelContext.insert(bufferPlayer)
                
                //if the player doesnt have the game, give the player the game
                
                /*
                 
                 if(bufferPlayer.games.firstIndex(of: newItem) != nil){
                    bufferPlayer.games.append(newItem)
                }
                 
                 */
                
                //save player
                newItem.players.append(bufferPlayer)
            
            }
        }
        //so i dont fuck up the names
        let teeboxName = "teebox"
        let holeName = "hole"
        let parName = "par"
        
        
        //create var to store Frames in
        var bufferFrame : Frame
        var bufferMod : Modifier
        var bufferScore : Score
        
        //create frames
        for i in 0..<framecount{
            //put new frame in buffer
            bufferFrame = Frame(holeNumber: i+1, game: newItem)
            
            //save frame
            modelContext.insert(bufferFrame)
            
            //create teebox
            bufferMod = Modifier(modifierType: .String(value: "enter Teebox Name"), name: teeboxName)
            modelContext.insert(bufferMod)
            bufferFrame.modifiers.append(bufferMod)
            
            //create hole
            bufferMod = Modifier(modifierType: .Arithmetic(value: 0), name: holeName)
            modelContext.insert(bufferMod)
            bufferFrame.modifiers.append(bufferMod)
            
            //create par
            bufferMod = Modifier(modifierType: .Arithmetic(value: 3), name: parName)
            modelContext.insert(bufferMod)
            bufferFrame.modifiers.append(bufferMod)
            
            
            
            //add players to the Frame
            for player in newItem.players {
                bufferScore = Score(player: player)
                modelContext.insert(bufferScore)
                
                bufferFrame.scores.append(bufferScore)
                bufferFrame.players.append(player)
                
                
            }
        }
        //modelContext.insert(newItem)
    }
}

#Preview {
    NewItemPage()
}
