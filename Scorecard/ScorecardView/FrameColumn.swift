//
//  FrameRow.swift
//  Scorecard
//
//  Created by Brett Garon on 10/13/24.
//

import SwiftUI

struct FrameColumn: View {
    @State var isShowingFramePage = false
    
    var passedFrame : Frame
    
    init(passedFrame: Frame) {
        self.passedFrame = passedFrame
    }
    var body: some View {
        ZStack{
            Button{
                isShowingFramePage.toggle()
            } label: {
                ScorecardRectangle(text: passedFrame.holeNumber.description)
            }.sheet(isPresented: $isShowingFramePage, content: {
                FrameInfo(selectedFrame: passedFrame)
            }).offset(y:0)
            ScorecardModifierStack(frame: passedFrame)
                .offset(y:45)
            ForEach(passedFrame.game?.players.sorted(by: >) ?? []){
                player in
                ScorecardRectangle(text: passedFrame.scores.first(where: {$0.player == player})?.score.description ?? "").offset(y:makePlayerOffset(index: passedFrame.game!.players.sorted(by: >).firstIndex(of: player)!))
            }
            
        }
    }
    func makePlayerOffset(index : Int)->CGFloat{
        var base = 135
        var step = 45
        var offset = step * (index+1)
        offset += base
        return CGFloat(offset)
    }
    
}

#Preview {
    FrameColumn(passedFrame: Frame(holeNumber: 1))
}
