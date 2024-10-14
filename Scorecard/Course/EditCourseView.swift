//
//  EditCourseView.swift
//  Scorecard
//
//  Created by Brett Garon on 10/1/24.
//  MVP 0.0.1 10/3/24

import SwiftUI

struct EditCourseView: View {
    
    var currentCourse : Course
    
    init(currentCourse: Course) {
        self.currentCourse = currentCourse
    }
    
    var body: some View {
        
        ScrollView(.horizontal){
            
            LazyHStack{
                
                ForEach(currentCourse.frames.sorted(by: <)){
                    frame in FrameModifierStack(currentFrame: frame)
                }
                
            }
            
        }
        
    }
}

#Preview {
    EditCourseView(currentCourse: Course())
}
