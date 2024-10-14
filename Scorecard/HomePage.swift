//
//  HomePage.swift
//  Scorecard
//
//  Created by Brett Garon on 9/10/24.
//  MVP 0.0.1 10/3/24 

import SwiftUI
import SwiftData

struct HomePage: View {
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
            
            VStack{
                
                HStack{
                    
                    if(!unfinishedGames.isEmpty){//i should be using more if statements in the body
                        NavigationLink{
                            UnfinishedGamesButton()
                        } label : {
                            Text("Current Games")
                        }
                    }
                    
                    NavigationLink{
                        TeeboxPage()
                    } label : {
                        Text("Teeboxes")
                    }
                    
                    NavigationLink{
                        CoursePage()
                    } label : {
                        Text("Courses")
                    }
                    
                    Spacer()
                    
                    NavigationLink{
                        PlayerListView()
                    } label: {
                        PlayerButton()
                    }
                    
                }
                
                NavigationLink{
                    ContentView()
                } label: {
                    GameButton()
                }
                
                Spacer()
                
            }
        }
    }
}

#Preview {
    HomePage()
}
