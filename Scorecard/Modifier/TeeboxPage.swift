//
//  TeeboxPage.swift
//  Scorecard
//
//  Created by Brett Garon on 9/30/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct TeeboxPage: View {
    @Environment(\.modelContext) private var modelContext
    
    //fetch all modifiers with the name teeboxPrototype
    static var fetchDescriptor: FetchDescriptor<FrameModifier> {
            let descriptor = FetchDescriptor<FrameModifier>(
                predicate: #Predicate { $0.name == "teeboxPrototype" }
            )
            return descriptor
        }
    
    @Query(TeeboxPage.fetchDescriptor) private var teeboxes: [FrameModifier]
    
    var body: some View {
        
        Button(action: {
            let newPrototype = FrameModifier(modifierType: .String(value: "New Teebox"), name: FrameModifierNames.teeboxPrototypeName)
            modelContext.insert(newPrototype)
        }, label: {
            Label("", systemImage: "plus")
        })
        
        List{
            //WE WANT TO BE DEALING WITH MODIFIERTYPES
            ForEach(teeboxes){ teebox in
                NavigationLink(generateModifierText(modifierType: teebox.modifierType), destination: FrameModifierView(modifier: teebox))
            }.onDelete(perform: deleteItems)
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(teeboxes[index])
            }
        }
    }
}

#Preview {
    TeeboxPage()
}
