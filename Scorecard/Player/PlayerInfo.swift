//
//  PlayerInfo.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct PlayerInfo: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var players : [Player]
    
    @State var name : String
    @State var showingNameEditor = false
    @State var shownMods = [PlayerModifier]()
    @State var showingStatSelector = false
    
    var currentPlayer : Player = Player()
    
    init(selectedPlayer : Player){
        currentPlayer = selectedPlayer
        _name = State(initialValue: selectedPlayer.name)
    }
    
    var body: some View {
        Spacer()
        
        HStack{
            
            Spacer()
            
            Button("edit name"){
                showingNameEditor.toggle()
            }.popover(isPresented: $showingNameEditor, content: {
                TextField(currentPlayer.name, text: $name)
                    .multilineTextAlignment(.center)
                    .presentationCompactAdaptation(.popover)
            }).onSubmit {
                saveInfo()
            }
            
        }
        
        Spacer(minLength: 110)
        Text(currentPlayer.name)
        Spacer()
        
        Text("Player Statistics")
        
        PlayerStatGenerator(selectedPlayer: currentPlayer)
        
        Button(action: deleteAllMods, label: {
            Text("Delete all mods")
        })
        
        ScrollView(.horizontal){
            
            LazyHStack{
                
                ForEach(currentPlayer.modifiers){
                    mod in
                    StatisticView(selectedMod: mod)
                }
                
            }
            
        }
        
        ScrollView(.horizontal){
            
            LazyHStack{
                
                ForEach(currentPlayer.games.sorted(by: >)){
                    game in
                    GameHistoryView(selectedItem: game)
                }
                
            }
            
        }
        
    }
    
    func deleteAllMods(){
        for mod in currentPlayer.modifiers{
            modelContext.delete(mod)
        }
        currentPlayer.modifiers.removeAll()
        modelContext.insert(currentPlayer)
    }
    
    /*
     * looks at all of the names of stats that exist for a certain player 
     * and then queries the modifiers for stats of that name
     * it then averages the values it gets and creates a modifier that holds that average
     * that modifier is added to the shown mods
     */
    func calcStats() {
        showingStatSelector.toggle()
//        var statistic : Double = 0.0
//        var modArray : [PlayerModifier] = []
//        
//        for modName in PlayerModifierNames.playerStatArray{
//            statistic = 0.0
//            
//            modArray = currentPlayer.modifiers.filter({$0.name == modName})
//            
//            for mod in modArray {
//                switch(mod.modifierType){
//                case .Double(let value):
//                    statistic += value
//                default: break
//                }
//            }
//            let shownStat = statistic / Double(modArray.count)
//            
//            let bufferMod = PlayerModifier(modifierType: .Double(value: shownStat), name: modName + " ")
//            
//            shownMods.append(bufferMod)
//            
//        }
    }
    
    func saveInfo(){
        currentPlayer.name = name
        modelContext.insert(currentPlayer)
    }
    
    
}

#Preview {
    PlayerInfo(selectedPlayer: Player(name: "John"))
}





