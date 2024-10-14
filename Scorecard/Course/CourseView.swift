//
//  CourseView.swift
//  Scorecard
//
//  Created by Brett Garon on 9/30/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct CourseView: View {
    @Environment(\.modelContext) private var modelContext
    
    //fetches all games with a descriptor that isnt an empty string
    static var fetchDescriptor: FetchDescriptor<Course> {
            let descriptor = FetchDescriptor<Course>(
                predicate: #Predicate { $0.descriptor == "" },
                sortBy: [
                    .init(\.timestamp)
                ]
            )
            return descriptor
        }


    @Query(CoursePage.fetchDescriptor) private var courses: [Course]
    
    var currentCourse : Course
    
    @State var courseName : String
    @State var showingCourseEditor = false
    
    
    init(currentCourse: Course) {
        self.currentCourse = currentCourse
        _courseName = State(initialValue: currentCourse.name)
    }
    

    var body: some View {
        
        NavigationSplitView{
            
            TextField(currentCourse.name, text: $courseName)
                .multilineTextAlignment(.center)
                .onSubmit {
                    currentCourse.name = courseName
                }
            
            
            Button(action: {
                editCourse()
            }) {
                Text("edit Course")
            }.sheet(isPresented: $showingCourseEditor, content: {
                EditCourseView(currentCourse: currentCourse)
            })
            
            
            List{
                ForEach(currentCourse.frames.sorted(by: <)){ frame in
                    NavigationLink(frame.holeNumber.description, destination: FrameInfo(selectedFrame: frame))
                } .onDelete(perform: deleteItems)
            }
            
        } detail: {
            Text("Select a course")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(courses[index])
            }
        }
    }
    
    private func editCourse(){
        showingCourseEditor.toggle()
    }
    
}

#Preview {
    CourseView(currentCourse: Course())
}
