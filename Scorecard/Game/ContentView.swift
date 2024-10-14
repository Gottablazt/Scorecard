//
//  ContentView.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    //all played games have no descriptor(empty string) atm
    static var fetchDescriptor: FetchDescriptor<Game> {
            let descriptor = FetchDescriptor<Game>(
                predicate: #Predicate { $0.descriptor == "" },
                sortBy: [
                    .init(\.timestamp, order: .reverse)
                ]
            )
            return descriptor
        }
    
    @Query(ContentView.fetchDescriptor) private var items: [Game]
    @Query private var players : [Player]
    
    @State var playerCount = 0
    @State private var newGameSheets = false
    @State private var showingPlayerSelection = false
    @State var possiblePlayers : [Player] = [Player]()
    @State private var showingNewItemPage = false
    @State var framecount  = 0
    
    
    let holeOptions = [0,1, 3, 6, 9,18]
    
    var body: some View {
        
        NavigationSplitView {
            
            HStack{
                
                EditButton()
                
                Button(action: togglePlayerSelection, label: {Text("New Game")})
                    .sheet(isPresented: $newGameSheets, content: {
                        Menu{
                            
                            ForEach(players){ player in
                                
                                Button(action: {
                                    possiblePlayers.append(player)
                                }, label: {
                                    Text(player.name)
                                }).disabled(possiblePlayers.contains(where: {$0.id == player.id}))
                                
                            }
                            
                        } label: {
                            Text("Select Players")
                        }
                        
                        Button(action: {
                            saveinfo()
                            togglePlayerSelection()
                        }, label: {
                            Text("Confirm")
                        })
                        
                    })
            }
            
            List {
                ForEach(items) { item in
                    
                    NavigationLink {
                        GamePage(selectedItem: item)
                    } label: {
                        
                        Text(generateGameLabel(game: item))
                    }
                    
                }.onDelete(perform: deleteItems)
            }
            
        } detail: {
              Text("Select an item")
        }
        
    }
    private func generateGameLabel(game : Game) -> String{
        var string = ""
        for player in game.players{
            string += player.name
            string += ", "
        }
        string.removeLast(2)
        if(game.course != nil){
            string += "at "
            string += game.course?.name ?? ""
        }
        string += " : "
        string += game.timestamp.formatted(date: .abbreviated, time: .shortened)
        return string
    }
    private func togglePlayerSelection(){
        playerCount=0
        possiblePlayers.removeAll()
        newGameSheets.toggle()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
                try? modelContext.save()
            }
        }
    }
    
    private func doneSelecting(){
        showingNewItemPage.toggle()
    }
    
    func saveinfo(){
        let newGame = Game()
        modelContext.insert(newGame)
        
        for player in possiblePlayers{
            newGame.players.append(player)
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Game.self, inMemory: true)
}


