//
//  ModifierStringPopup.swift
//  Scorecard
//
//  Created by Brett Garon on 9/28/24.
//

import SwiftUI

struct ModifierStringPopup: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var modifier : Modifier
    @State var stringValue : String

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
            .onSubmit {
                modifier.modifierType = .String(value: stringValue)
                modelContext.insert(modifier)
                dismiss()
            }
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ModifierStringPopup(modifier: Modifier(modifierType: .String(value: "hi"), name: "teebox"))
}
