//
//  FrameInfo.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//

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
    
    func addTeebox(){
        
    }
    func addHole(){
        
    }
    func setDefaultPar(){
        
    }
    func addPar(){
        
    }
        
    var body: some View {
        
        Text("Hole Number")
        Text(currentFrame.holeNumber.description)
        VStack{
            ForEach(currentFrame.modifiers){modifier in
                ModifierView(modifier: modifier)
            }
        }
        Text("Scores")
        HStack{
            ForEach(currentFrame.scores) { score in
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
