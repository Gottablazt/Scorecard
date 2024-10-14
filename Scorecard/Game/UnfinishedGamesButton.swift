//
//  UnfinishedGamesButton.swift
//  Scorecard
//
//  Created by Brett Garon on 10/12/24.
//

import SwiftUI
import SwiftData


struct UnfinishedGamesButton: View {
    @Environment(\.modelContext) private var modelContext
    
    static var fetchDescriptor: FetchDescriptor<Game> {
            let descriptor = FetchDescriptor<Game>(
                predicate: #Predicate {!$0.isFinished},
                sortBy: [
                    .init(\.timestamp)
                ]
            )
            return descriptor
        }

    @Query(HomePage.fetchDescriptor) private var unfinishedGames: [Game]
    
   
    var body: some View {
        NavigationView{
            List{
                ForEach(unfinishedGames, id: \.self){
                    game in
                    NavigationLink{
                        GamePage(selectedItem: game)
                    } label : {
                        Text(generateGameLabel(game: game))
                    }
                }
            }
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
}

#Preview {
    UnfinishedGamesButton()
}
