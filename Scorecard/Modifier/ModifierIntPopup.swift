//
//  TeeboxPopup.swift
//  Scorecard
//
//  Created by Brett Garon on 9/27/24.
//

import SwiftUI
import SwiftData

struct ModifierIntPopup: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var selectedMod : Modifier
    @State var intValue : Int
    
    let numericOptions = [Int].init(0...10)
    
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
    func submit(){
        selectedMod.modifierType = .Arithmetic(value: intValue)
        modelContext.insert(selectedMod)
        dismiss()
    }
    var body: some View {
        VStack{
            Button("Done", action: submit)
            Picker(selection: $intValue, label: Text("Select the value for \(selectedMod.name)")){
                ForEach(numericOptions, id: \.self){
                    op in
                    Text(op.description).tag(op)
                }
            }
        }
    }
}

#Preview {
    ModifierIntPopup(modifier: Modifier(modifierType: .Arithmetic(value: 0), name: "teebox"))
}
