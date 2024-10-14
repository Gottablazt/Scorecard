//
//  FrameInfo.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct FrameInfo: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Frame.holeNumber) private var frames : [Frame]
    
    var currentFrame : Frame = Frame()
    var players : [Player] = [Player]()

    
    init(selectedFrame : Frame){
        currentFrame = selectedFrame
       
    }
    
    init(frameIndex : Int){
        currentFrame = frames[frameIndex]
    }
        
    var body: some View {
        Spacer()
        Text("Hole Number")
        FrameModifierStack(currentFrame: currentFrame)
        
        Text("Scores")
        
        HStack{
            
            ForEach(currentFrame.scores.sorted(by: >)) { score in
                
                VStack{
                    ScoreInfo(score: score)
                }
                
            }
            
        }
        
        Spacer()
        
    }
    
    
}

#Preview {
    FrameInfo(selectedFrame: Frame())
}
