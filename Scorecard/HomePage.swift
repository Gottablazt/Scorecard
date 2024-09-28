//
//  HomePage.swift
//  Scorecard
//
//  Created by Brett Garon on 9/10/24.
//

import SwiftUI

struct HomePage: View {
    
    var currentGame : Item?
    init(currentGame: Item? = nil) {
        self.currentGame = currentGame
    }
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    if(currentGame != nil){
                        NavigationLink{
                            GamePage(selectedItem: currentGame ?? Item())
                        } label: {
                            Text("Current Game")
                        }
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
