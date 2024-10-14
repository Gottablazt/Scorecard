//
//  ScorecardApp.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

@main
struct ScorecardApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Score.self,
            Frame.self,
            Player.self,
            Game.self,
            Course.self,
            GameModifier.self,
            FrameModifier.self,
            PlayerModifier.self,
            ScoreModifier.self,
            CourseModifier.self

        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()


    
    /*
     * Runs on startup
     * looks for any items that arent finished
     * return the first item that isnt finished
     * this can be done better
     */
    
    var body: some Scene {
        WindowGroup{
            HomePage()
        }.modelContainer(sharedModelContainer)
    }
    
}
