//
//  ContentView.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var showingNewItemPage = false
    
    var body: some View {
        Text("GamePage")
        NavigationSplitView {
            HStack{
                EditButton()
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
                .sheet(isPresented: $showingNewItemPage){
                    NewItemPage()
                }
            }
            List {
                ForEach(items) { item in
                    NavigationLink {
                        GamePage(selectedItem: item)                    } label: {
                            Text(item.timestamp.formatted(date: .abbreviated, time: .omitted))
                    }
                }
                .onDelete(perform: deleteItems)
            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                    .sheet(isPresented: $showingNewItemPage){
//                        NewItemPage()
//                    }
//                }
//            }
        } detail: {
              Text("Select an item")
        }
    }

    private func addItem() {
        showingNewItemPage = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
