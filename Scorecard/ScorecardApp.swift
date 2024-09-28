//
//  ScorecardApp.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//

import SwiftUI
import SwiftData

@main
struct ScorecardApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Score.self,
            Frame.self,
            Player.self,
            Item.self,
            Modifier.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    func determineStartingWindow() -> Item?{
        let descriptor = FetchDescriptor<Item>()
        var items = [Item]()
        
        do {
            items = try ModelContext(sharedModelContainer).fetch(descriptor)
        } catch {
            fatalError("ya fucked up your window logic: \(error)")
        }
        
        for item in items {
            if(!item.isFinished){
                return item
            }
        }
        return nil
    }
    
    var body: some Scene {
        WindowGroup{
            HomePage(currentGame: determineStartingWindow())
        }.modelContainer(sharedModelContainer)
    }
}
