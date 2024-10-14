//
//  ModifierStringPopup.swift
//  Scorecard
//
//  Created by Brett Garon on 9/28/24.
//  MVP 0.0.1 10/3/24

import SwiftUI

struct FrameModifierStringPopup: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var stringValue : String

    var modifier : Modifier
    
    init(modifier : Modifier){
        
        self.modifier = modifier
        
        switch(modifier.modifierType){
            case .String(let value):
                _stringValue = State(initialValue: value)
                break
            default:
                _stringValue = State(initialValue: "")

            }
        
    }
    
    var body: some View {
        
        TextField(modifier.name, text: $stringValue)
            .multilineTextAlignment(.center)
            .onSubmit {
                modifier.modifierType = .String(value: stringValue)
                modelContext.insert(modifier)
                dismiss()
            }
        
    }
    
}

#Preview {
    FrameModifierStringPopup(modifier: Modifier(modifierType: .String(value: "hi"), name: "teebox"))
}
