//
//  CourseFrameEditor.swift
//  Scorecard
//
//  Created by Brett Garon on 10/1/24.
//  MVP 0.0.1 10/3/24

import SwiftUI

struct FrameModifierStack: View {
    
    var currentFrame : Frame
    
    init(currentFrame: Frame) {
        self.currentFrame = currentFrame
    }
    
    var body: some View {
        
        VStack{
            
            Text(currentFrame.holeNumber.description)
            
            FrameModifierView(modifier: currentFrame.modifiers.first(where: {$0.name == FrameModifierNames.teeboxName}) ?? FrameModifier(modifierType: .String(value: "couldnt Find Teebox"), name: FrameModifierNames.teeboxName))
            
            FrameModifierView(modifier: currentFrame.modifiers.first(where: {$0.name == FrameModifierNames.holeName}) ?? FrameModifier(modifierType: .Arithmetic(value: 1), name: FrameModifierNames.holeName))
            
            FrameModifierView(modifier: currentFrame.modifiers.first(where: {$0.name == FrameModifierNames.parName}) ?? FrameModifier(modifierType: .Arithmetic(value: 3), name: FrameModifierNames.parName))
            
        }
    }
}

#Preview {
    FrameModifierStack(currentFrame: Frame())
}
