//
//  ModifierTeeboxPicker.swift
//  Scorecard
//
//  Created by Brett Garon on 9/30/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct ModifierTeeboxPicker: View {
    //this might need to know the teebox that it is in
    @Environment(\.modelContext) private var modelContext
    
    //fetch all modifiers with the name teeboxPrototype
    static var fetchDescriptor: FetchDescriptor<FrameModifier> {
            let descriptor = FetchDescriptor<FrameModifier>(
                predicate: #Predicate { $0.name == "teeboxPrototype" }
            )
            return descriptor
        }

    @Query(ModifierTeeboxPicker.fetchDescriptor) private var teeboxPrototypes: [FrameModifier]
    
    var currentModifier : FrameModifier
    
    init(modifier : FrameModifier) {
        currentModifier = modifier
    }
    
    var body: some View {
        
        Menu{
            
            ForEach(teeboxPrototypes){ prototype in
                
                Button(action: {
                    currentModifier.modifierType = prototype.modifierType
                }, label: {
                    Text(generateModifierText(modifierType: prototype.modifierType))
                })
                
            }
            
            Button(action: {
                let newPrototype = FrameModifier(modifierType: .String(value: "New Teebox"), name: FrameModifierNames.teeboxPrototypeName)
                modelContext.insert(newPrototype)
                currentModifier.modifierType = newPrototype.modifierType
            }, label: {
                Text("Create New TeeBox")
            })
            
        } label: {
            Text("Select Teebox")
        }
        
    }
    
    func generateModifierText(modifierType : ModifierType) -> String{
        
        switch(modifierType){
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
    ModifierTeeboxPicker(modifier: FrameModifier(modifierType: .String(value: ""), name: "teebox"))
}
