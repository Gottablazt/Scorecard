//
//  ScorecardRectangle.swift
//  Scorecard
//
//  Created by Brett Garon on 10/13/24.
//

import SwiftUI

struct ScorecardRectangle: View {
    var text : String
    init(text: String) {
        self.text = text
    }
    var body: some View {
        Rectangle()
            .frame(width: 75, height: 50)
            .foregroundStyle(.clear)
            .border(.black, width: 5)
            .overlay(content: {
                Text(text)
            })
    }
}

#Preview {
    ScorecardRectangle(text: "Hello World")
}
