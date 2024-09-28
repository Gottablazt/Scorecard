//
//  ScoreInfo.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//

import SwiftUI
import SwiftData

struct ScoreInfo: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var currentScore : Score
    init(score : Score){
        self.currentScore = score
    }
    var body: some View {
        Text(currentScore.player?.name ?? "")
        Text(currentScore.score.description)
        Button("+", action: incrementScore)
        Button("R", action : resetScore)
    }
    
    func incrementScore(){
        currentScore.score += 1
    }
    func resetScore(){
        currentScore.score = 0
    }
}

#Preview {
    ScoreInfo(score: Score())
}
