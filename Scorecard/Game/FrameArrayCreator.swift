//
//  NewItemPage.swift
//  Scorecard
//
//  Created by Brett Garon on 9/9/24.
//

import SwiftUI
import SwiftData



struct FrameArrayCreator: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var items : [Item]
  
   
    var newItem = Item()

    @State var framecount : Int
    let holeOptions = [0,1, 3, 6, 9,18]
 
    @State var isSaved = false
    
    
    init(){
        _framecount = State(initialValue: 0)
    }
    
    
    var body: some View {
        VStack{
            
        }
    }

    private func addFramestoGame(frameCount : Int, item : Item){
        modelContext.insert(item)
        
    }
    //THIS NEEDS WORK
    private func saveInfo(){
        addFramestoGame(frameCount: framecount, item: newItem)
    }
}

#Preview {
    FrameArrayCreator()
}
