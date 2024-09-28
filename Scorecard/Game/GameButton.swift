//
//  GameButton.swift
//  Scorecard
//
//  Created by Brett Garon on 9/19/24.
//

import SwiftUI

struct Triangle : Shape {
    func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            }
        }
}

struct GameButton: View {
    
    var body: some View {
        GolfGraphic()
            .overlay{
                Text("Tee off")
                    .offset(CGSize(width: -10.0, height: 150.0))
                    .font(.custom("", fixedSize: 50))
                    .foregroundStyle(.black)
                Rectangle()
                    .frame(width: 6, height: 60)
                    .offset(CGSize(width: 60, height: -115))
                    .foregroundStyle(.black)
                    .overlay{
                        Triangle()
                            .path(in: CGRect(origin: CGPoint(x: -150, y: -60), size: CGSize(width: 20, height: 30)))
                            .foregroundStyle(.red)
                            .rotationEffect(Angle(degrees: 90))
                    }
            }
    }
}

#Preview {
    GameButton()
}
