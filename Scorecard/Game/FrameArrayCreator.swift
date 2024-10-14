//
//  NewItemPage.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//

import SwiftUI
import SwiftData



struct FrameArrayCreator: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var items : [Item]
  
    @State var framecount : Int
    var newItem = Item()


    let holeOptions = [0,1, 3, 6, 9,18]
 
    @State var isSaved = false
    
    
    init(){
        _framecount = State(initialValue: 0)
    }
    
    
    var body: some View {
        VStack{
            Text("Number of Holes To Play")
            Picker(selection: $framecount, label: Text("Select the number of frames you would like to play")){
                ForEach(holeOptions, id: \.self){
                    hole in Text("\(hole)").tag(hole)
                }
            }
            .onChange(of: framecount){
                saveInfo()
                dismiss()
            }
        }
    }

    private func addFramestoGame(frameCount : Int, item : Item){
        modelContext.insert(item)
        //create var to store Frames in
        var bufferFrame : Frame
        var bufferMod : Modifier
        var bufferScore : Score
        
        //create frames
        for i in 0..<framecount{
            
            
            //so i dont fuck up the names
            let teeboxName = ModifierNames.teeboxName
            let holeName = ModifierNames.holeName
            let parName = ModifierNames.parName
            
            
            
            //put new frame in buffer
            bufferFrame = Frame(holeNumber: i+1, game: item)
            
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
            
            for player in item.players {
                bufferScore = Score(player: player)
                modelContext.insert(bufferScore)
                
                bufferFrame.scores.append(bufferScore)
                bufferFrame.players.append(player)
                
                
            }
        }
    }
    //THIS NEEDS WORK
    private func saveInfo(){
        addFramestoGame(frameCount: framecount, item: newItem)
    }
}

#Preview {
    FrameArrayCreator()
}
