//
//  ScorecardModifierStack.swift
//  Scorecard
//
//  Created by Brett Garon on 10/13/24.
//

import SwiftUI

struct ScorecardModifierStack: View {
    var frame : Frame
    init(frame: Frame) {
        self.frame = frame
    }
    var body: some View {
        ZStack{
            ScorecardRectangle(text: getModText(mod: frame.modifiers.first(where: {$0.name == FrameModifierNames.teeboxName})!))
                .offset(y:0)
            ScorecardRectangle(text: getModText(mod: frame.modifiers.first(where: {$0.name == FrameModifierNames.holeName})!))
                .offset(y:45)
            ScorecardRectangle(text: getModText(mod: frame.modifiers.first(where: {$0.name == FrameModifierNames.parName})!))
                .offset(y:90)
        }
    }
    
    func getModText(mod : FrameModifier) -> String{
        switch(mod.modifierType){
            
            case .Arithmetic(let value):
                return value.description
                
            case .String(let value):
                return value
            
            case .Double(let value):
                return value.description
            
            case .Bool(value: let value):
                return value.description
            }
    }
}

#Preview {
    ScorecardModifierStack(frame: Frame())
}
