//
//  TeeboxPopup.swift
//  Scorecard
//
//  Created by Brett Garon on 9/27/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct FrameModifierIntPopup: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var intValue : Int
    
    let numericOptions = [Int].init(0...4)
    
    var selectedMod : Modifier
    
    init(modifier : Modifier) {
        selectedMod = modifier
        
        switch(modifier.modifierType){
            
            case .Arithmetic(let value):
            
                _intValue = State(initialValue: value)
                break
                    
            default:
                _intValue = State(initialValue: 0)

        }
        
    }
    
    var body: some View {
        
        VStack{
            
            Button("Done", action: submit)
            
            Picker(selection: $intValue, label: Text("Select the value for \(selectedMod.name)")){
                ForEach(numericOptions, id: \.self){ op in
                    Text(op.description).tag(op)
                }
            }
            
        }
        
    }
    
    func submit(){
        selectedMod.modifierType = .Arithmetic(value: intValue)
        modelContext.insert(selectedMod)
        dismiss()
    }
    
}

#Preview {
    FrameModifierIntPopup(modifier: Modifier(modifierType: .Arithmetic(value: 0), name: "teebox"))
}
