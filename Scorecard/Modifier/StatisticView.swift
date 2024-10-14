//
//  StatisticView.swift
//  Scorecard
//
//  Created by Brett Garon on 9/29/24.
//  MVP 0.0.1 10/3/24

import SwiftUI

struct StatisticView: View {
    
    var selectedMod : PlayerModifier
    
    init(selectedMod: PlayerModifier) {
        self.selectedMod = selectedMod
    }
    
    
    var body: some View {
        
        Rectangle()
            .frame(width: 200, height: 100)
            .foregroundStyle(.secondary)
            .overlay{
                
                VStack{
                    
                    Spacer()
                    Text(selectedMod.name)
                    
                    Spacer(minLength: 20)
                    Text(generateModifierText(modifierType: selectedMod.modifierType))
                    Spacer()
                    
                }
                
            }
        
    }
    
    
    func generateModifierText(modifierType : ModifierType) -> String{
        
        switch(modifierType){
            
            case .Arithmetic(let value):
                return value.description
            case .String(let value):
                return value
            case .Double(let value):
                let format = NumberFormatter()
                format.maximumFractionDigits = 3
                format.numberStyle = .decimal
                return format.string(for: value) ?? ""
            case .Bool(value: let value):
                return value.description
        }
        
    }
    
}

#Preview {
    StatisticView(selectedMod: PlayerModifier(modifierType: .Double(value: 3.0), name: "Average strokes per hole"))
}
