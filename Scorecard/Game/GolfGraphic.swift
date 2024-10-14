//
//  GameButton.swift
//  Scorecard
//
//  Created by Brett Garon on 9/19/24.
//  MVP 0.0.1 10/3/24

import SwiftUI

struct GolfGraphic: View {
    
    var body: some View {
        
        Ellipse()
            .frame(width: 150, height: 350)
            .foregroundStyle(Color(red: 0.14, green: 0.43, blue: 0.15))
            .rotationEffect(.degrees(25))
            .overlay{
                
                Ellipse()
                    .offset(x: -10, y:130)
                    .frame(width: 190, height: 390)
                    .foregroundStyle(Color(red: 0.14, green: 0.43, blue: 0.15))
                
                Ellipse()
                    .offset(CGSize(width: 20.0, height: -70.0))
                    .frame(width: 90, height: 140)
                    .foregroundStyle(Color(red: 0.14, green: 0.63, blue: 0.25))
                    .rotationEffect(.degrees(15))
                
                Ellipse()
                    .offset(CGSize(width: 180.0, height: 290.0))
                    .frame(width: 90, height: 140)
                    .foregroundStyle(Color(red: 0.14, green: 0.43, blue: 0.15))
                    .rotationEffect(.degrees(15))

            }
        
    }
    
}

#Preview {
    GolfGraphic()
}
