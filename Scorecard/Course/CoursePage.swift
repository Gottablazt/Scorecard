//
//  CoursePage.swift
//  Scorecard
//
//  Created by Brett Garon on 9/30/24.
//  MVP 0.0.1 10/3/24 

import SwiftUI
import SwiftData

struct CoursePage: View {
    
    @Environment(\.modelContext) private var modelContext
    
    //this fetch descriptor fetches all Games with a description as played games get no descriptor
    static var fetchDescriptor: FetchDescriptor<Course> {
            let descriptor = FetchDescriptor<Course>(
//                predicate: #Predicate {$0.descriptor.contains("")}, //change this
                sortBy: [
                    .init(\.timestamp)
                ]
            )
            return descriptor
        }

    @Query(CoursePage.fetchDescriptor) private var courses: [Course]
    
    
    /*
     * Function Creates a new Game with the a string descriptor "Course"
     * this new Game gets 18 Frames and the modifiers that come with those 18 frames
     * they hold empty player and score arrays
     * Game is marked finished so that the current game button doesn't see it
     */
    func addCourse(){
        let newCourse = Course()
        modelContext.insert(newCourse)
        var bufferFrame : Frame
        for i in 1...18{
            bufferFrame = Frame(holeNumber: i)
            
            var bufferMod : FrameModifier
            // this isnt causing any lag at the moment but could potentially lead to issues/slowdowns
            
            
            //so i dont fuck up the names
            let teeboxName = "teebox"
            let holeName = "hole"
            let parName = "par"
            
            
            //create teebox
            bufferMod = FrameModifier(modifierType: .String(value: "enter Teebox Name"), name: teeboxName)
            modelContext.insert(bufferMod)
            bufferFrame.modifiers.append(bufferMod)
            
            //create hole
            bufferMod = FrameModifier(modifierType: .Arithmetic(value: 0), name: holeName)
            modelContext.insert(bufferMod)
            bufferFrame.modifiers.append(bufferMod)
            
            //create par
            bufferMod = FrameModifier(modifierType: .Arithmetic(value: 3), name: parName)
            modelContext.insert(bufferMod)
            bufferFrame.modifiers.append(bufferMod)
            
            
            newCourse.frames.append(bufferFrame)
        }
        newCourse.name = "New Course"
    }
    
    
    var body: some View {
        
        
        Button(action: {
            addCourse()
        }, label: {
            Text("add Course")
        })
        
        
        List{
            ForEach(courses){ course in
                NavigationLink{
                    CourseView(currentCourse: course)
                } label : {
                    Text(course.name)
                }
                
            }.onDelete(perform: deleteItems)
        }
        
        
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(courses[index])
            }
        }
    }
    
}

#Preview {
    CoursePage()
}
