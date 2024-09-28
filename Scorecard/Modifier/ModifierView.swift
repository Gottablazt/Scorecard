//
//  ModifierView.swift
//  Scorecard
//
//  Created by Brett Garon on 9/27/24.
//

import SwiftUI
import SwiftData

struct ModifierView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var modifier : Modifier
    @State var isEditingInt = false
    @State var isEditingString = false
    
    
    
    
    init(modifier: Modifier) {
        self.modifier = modifier
    }
    
    var body: some View {
        Text(modifier.name)
        Button(generateModifierText(modifierType: modifier.modifierType)){
            
            switch(modifier.modifierType){
                
                case .Arithmetic:
                    isEditingInt.toggle()
                
                case .String:
                    isEditingString.toggle()
                
                default : break
                
            }
            
        }
        .popover(isPresented: $isEditingInt, content: {
            ModifierIntPopup(modifier: modifier)
                .presentationCompactAdaptation(.popover)
        })
        .popover(isPresented: $isEditingString, content: {
            ModifierStringPopup(modifier: modifier)
                .presentationCompactAdaptation(.popover)
        })
        
    }
    
    func generateModifierText(modifierType : ModifierType) -> String{
        switch(modifierType){
        case .Arithmetic(let value):
            return value.description
        case .String(let value):
            return value
        case .Double(let value):
            return value.description
        }
        
    }
}

#Preview {
    ModifierView(modifier: Modifier(modifierType: .Arithmetic(value: 3), name: "Par"))
}
