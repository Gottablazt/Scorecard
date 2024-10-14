//
//  FramePage.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//  MVP 0.0.1 10/3/24

import SwiftUI
import SwiftData

struct FramePage: View {
    @Environment(\.modelContext) private var modelContext

    
    //looks for all games with an empty string descriptor(played games)
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
    @Query private var games: [Game]
   
    @State var frameCountSelector = false
    var currentItem : Game = Game()
    
    init(selectedItem : Game){
        self.currentItem = selectedItem
    }
    
    init(itemIndex : Int) {
        currentItem = games[itemIndex]
    }
    
    var body: some View {
        
        Text("FramePage")
        
        Button("Determine Winner", action: finalizeGame)
        
        Text(currentItem.winner)
        
        Text(currentItem.finalScoreString)
        
        NavigationSplitView{
            
            List{
                
                ForEach(currentItem.frames.sorted(by: <)){ frame in
                    NavigationLink(frame.holeNumber.description, destination: FrameInfo(selectedFrame: frame))
                }.onDelete(perform: deleteItems)
                
            }.toolbar{
                
                ToolbarItem{
                    
                    Menu{
                        
                        ForEach(courses){ course in
                            
                            Button(action: {
                                selectCourse(course: course)
                            }, label: {
                                Text(course.name)
                            })
                            
                        }
                        
                    } label: {
                        
                        Text("play Course")
                        
                    }.disabled(!currentItem.frames.isEmpty)
                    
                }
                
                ToolbarItem {
                    
                    Menu{
                        
                        Button("1", action: {
                            addFrame()
                        })
                        
                        Button("3", action: {
                            for _ in 0..<3{
                                addFrame()
                            }
                        })
                        
                        Button("6", action: {
                            for _ in 0..<6{
                                addFrame()
                            }
                        })
                        
                        Button("9", action: {
                            for _ in 0..<9{
                                addFrame()
                            }
                        })
                        
                        Button("18", action: {
                            for _ in 0..<18{
                                addFrame()
                            }
                        })
                        
                    } label: {
                        Text("select Frame Count")
                    }.disabled(!currentItem.frames.isEmpty)
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem{
                    Button(action: addFrame) {
                        Label("", systemImage: "plus")
                    }
                }
                
            }
            
        } detail: {
            Text("Select an item")
        }
        
    }
    
    /*
     * Copies all modifiers into new frames and puts them into the new game
     */
    private func selectCourse(course : Course){
        var bufferFrame : Frame
        var bufferScore : Score
        var bufferMod : FrameModifier
        for frame in course.frames{
            
            bufferFrame = Frame(holeNumber: frame.holeNumber ,game: currentItem)
            
            modelContext.insert(bufferFrame)
            
            for player in currentItem.players {
                bufferFrame.players.append(player)
                bufferScore = Score()
                modelContext.insert(bufferScore)
                bufferScore.player = player
                bufferFrame.scores.append(bufferScore)
            }
            
            
            for modifier in frame.modifiers{
                bufferMod = FrameModifier(modifierType: modifier.modifierType, name: modifier.name)
                modelContext.insert(bufferMod)
                bufferFrame.modifiers.append(bufferMod)
            }
            
            currentItem.frames.append(bufferFrame)
        }
        currentItem.course = course
    }
    
    /*
     * creates a dictionary for players to hold their final scores
     * returns that dictionary with player final stroke count
     */
    private func createPlayerScores(game : Game) -> [Player : Int]{
        var scores : [Player : Int] = [:]
        
        for player in game.players {
            scores[player] = 0
        }
        
        for frame in game.frames {
            for score in frame.scores {
                scores[score.player ?? Player()]! += score.score
            }
        }
       
        return scores
    }
    
    /*
     * goes through all par modifiers and adds them up and returns that value
     */
    private func findGamePar(game : Game) -> Int{
        var parScore = 0
        var frameParModifier : ModifierType

        for frame in currentItem.frames {
            
            frameParModifier = frame.modifiers.first(where: {$0.name == "par"})?.modifierType ?? .Arithmetic(value: 3)
            
            switch(frameParModifier){
                case .Arithmetic(let value) :
                    parScore += value
                default :
                    parScore += 3
            }
        }
        
        return parScore
    }
    
    
    /*
     * finds strokes and par adjusted score and finalizes game
     */
    private func finalizeGame(){
        
        let scores = createPlayerScores(game: currentItem)
        let parScore = findGamePar(game: currentItem)

//        
        let winner = scores.max{a,b in a.value > b.value}
        currentItem.winner = winner?.key.name ?? ""
        
        var newWinnerString = ""
        var playerScore : Int
        var playerStrokes: Int
        var playerScoreString = ""
        
        
        for player in currentItem.players {
            
            playerStrokes = scores[player] ?? parScore
            
            playerScore = playerStrokes - parScore
            
            playerScoreString = (playerScore.description)
            
            newWinnerString += player.name + "(" + playerScoreString + ") "
        }
        
        currentItem.finalScoreString = newWinnerString
        currentItem.isFinished = true
    }
    
    
    
    /*
     *  Creates a frame with the same players as the game and gives it 3 modifiers
     */
    private func addFrame() {
        withAnimation {
            
            let newFrame = Frame(holeNumber: currentItem.frames.count+1)
            modelContext.insert(newFrame)
            
            newFrame.game = currentItem
            newFrame.players = currentItem.players
            var bufferScore : Score
            for player in newFrame.players {
                bufferScore = Score()
                modelContext.insert(bufferScore)
                bufferScore.player = player
                newFrame.scores.append(bufferScore)
            }
            
            var bufferMod : FrameModifier
            //so i dont fuck up the names
            let teeboxName = "teebox"
            let holeName = "hole"
            let parName = "par"
            
            
            //create teebox
            bufferMod = FrameModifier(modifierType: .String(value: "enter Teebox Name"), name: teeboxName)
            modelContext.insert(bufferMod)
            newFrame.modifiers.append(bufferMod)
            
            //create hole
            bufferMod = FrameModifier(modifierType: .Arithmetic(value: 0), name: holeName)
            modelContext.insert(bufferMod)
            newFrame.modifiers.append(bufferMod)
            
            //create par
            bufferMod = FrameModifier(modifierType: .Arithmetic(value: 3), name: parName)
            modelContext.insert(bufferMod)
            newFrame.modifiers.append(bufferMod)
            
            
            currentItem.frames.append(newFrame)
            
        }
    }
    
    private func addFrames(){
        frameCountSelector.toggle()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                
                var frameToDelete = currentItem.frames.sorted(by: <)[index]
                
                modelContext.delete(frameToDelete)
                
                currentItem.frames.remove(at: currentItem.frames.firstIndex(of: frameToDelete)!)
            }
        }
    }
    
}

#Preview {
    FramePage(itemIndex: 0)
}
