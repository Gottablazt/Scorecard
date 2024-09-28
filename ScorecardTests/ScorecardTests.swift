//
//  ScorecardTests.swift
//  ScorecardTests
//
//  Created by Brett Garon on 8/28/24.
//

import XCTest
@testable import Scorecard
import SwiftData

@MainActor
final class ScorecardTests: XCTestCase {
    
    var context : ModelContext? = nil
    
    override func setUpWithError() throws {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Frame.self, Item.self, Player.self, Score.self, Modifier.self, configurations: config)
        context = container.mainContext
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual(context!.insertedModelsArray.count, 0, "There should be 0 models when the app is first launched.")
    }
    
    
    func testEmptyPlayerCreation() throws {
        let newPlayer = Player()
        context?.insert(newPlayer)
        
        XCTAssert(context?.insertedModelsArray.count == 1 && context?.insertedModelsArray.first?.id == newPlayer.id)
    }
    
    func testNamedPlayerCreation() throws {
        let newPlayer = Player(name: "A")
        context?.insert(newPlayer)
        
        XCTAssert(context?.insertedModelsArray.count == 1 && context?.insertedModelsArray.first?.id == newPlayer.id)
    }
    
    func testAppendingGameToPlayerAppendsGame() throws{
        let newPlayer = Player()
        context?.insert(newPlayer)
        
        let newGame = Item()
        context?.insert(newGame)
        
        newGame.players.append(newPlayer)
        newPlayer.games.append(newGame)
        
        
        
        let gameDescriptor = FetchDescriptor<Item>()
        let otherGame = try! context?.fetch(gameDescriptor).first
        let gamePlayer = otherGame?.players.first
        
        XCTAssert(gamePlayer?.id == newPlayer.id && newPlayer.games.first?.id == otherGame?.id)
    }
    

    func testEmptyScoreCreation() throws {
        let newScore = Score()
        context?.insert(newScore)
        
        XCTAssert(context?.insertedModelsArray.count == 1 && context?.insertedModelsArray.first?.id == newScore.id)
    }
    
    func testScoreCreationWithFrameHasFrame() throws {
        let newScore = Score()
        context?.insert(newScore)
        
        let newFrame = Frame()
        context?.insert(newFrame)
        newScore.frame = newFrame
        
        
        let descriptor = FetchDescriptor<Score>()
        
        let otherScore = try! context?.fetch(descriptor).first
        
        XCTAssert(newScore.id == otherScore?.id && otherScore?.frame?.id == newFrame.id)
    }
    
    func testScoreCreationWithPlayerHasPlayer() throws {
        let newScore = Score()
        context?.insert(newScore)
        
        let newPlayer = Player()
        context?.insert(newPlayer)
        newScore.player = newPlayer
        
        
        let descriptor = FetchDescriptor<Score>()
        
        let otherScore = try! context?.fetch(descriptor).first
        
        XCTAssert(newScore.id == otherScore?.id && otherScore?.player?.id == newPlayer.id)
    }
    
    func testChangingScoreChangesScore() throws {
        let newScore = Score()
        context?.insert(newScore)
        
        newScore.score = 3
        
        let descriptor = FetchDescriptor<Score>()
        
        let otherScore = try! context?.fetch(descriptor).first
        
        XCTAssert(newScore.id == otherScore?.id && otherScore?.score == newScore.score)
    }
    
    
    
    func testEmptyFrameCreation() throws {
        let newFrame = Frame()
        context?.insert(newFrame)
        
        XCTAssert(context?.insertedModelsArray.count == 1 && context?.insertedModelsArray.first?.id == newFrame.id)
    }
    
    func testFrameCreationWithPlayersHasPlayers() throws {
        let newFrame = Frame()
        context?.insert(newFrame)
        
        let players = [Player()]
        
        for player in players {
            context!.insert(player)
            newFrame.players.append(player)
        }
        
        
        let descriptor = FetchDescriptor<Frame>()
        
        
        let otherFrame = try! context?.fetch(descriptor).first
        
        XCTAssert(otherFrame?.id == newFrame.id && !newFrame.players.isEmpty)
    }
    
    func testFrameCreationWithScoresHasScores() throws {
        let newFrame = Frame()
        context?.insert(newFrame)
        
        let scores = [Score()]
        
        for score in scores {
            context!.insert(score)
            newFrame.scores.append(score)
        }
        
        
        let descriptor = FetchDescriptor<Frame>()
        
        
        let otherFrame = try! context?.fetch(descriptor).first
        
        XCTAssert(otherFrame?.id == newFrame.id && newFrame.scores.first?.id == scores.first?.id)
    }
    
    func testFrameWithModifiersHasModifiers() throws{
        let newFrame = Frame()
        context?.insert(newFrame)
        
        let modifier = Modifier(modifierType: .Arithmetic(value: 3), name: "Par")
        context?.insert(modifier)
        
        newFrame.modifiers.append(modifier)
        
        let descriptor = FetchDescriptor<Frame>()
        
        
        let otherFrame = try! context?.fetch(descriptor).first
        
        XCTAssert(otherFrame?.id == newFrame.id && newFrame.modifiers.first?.id == modifier.id)
    }
    
    func testFrameCanHoldMultipleModifiers(){
        let newFrame = Frame()
        context?.insert(newFrame)
        
        let modifier = Modifier(modifierType: .Arithmetic(value: 3), name: "Par")
        context?.insert(modifier)
        
        newFrame.modifiers.append(modifier)
        
        let modifier2 = Modifier(modifierType: .String(value: "Door"), name: "Teebox")
        context?.insert(modifier2)
        newFrame.modifiers.append(modifier2)
        
        let modifier3 = Modifier(modifierType: .Arithmetic(value: 2), name: "Hole")
        context?.insert(modifier3)
        newFrame.modifiers.append(modifier3)
        
        
        
        
        let descriptor = FetchDescriptor<Frame>()
        
        
        let otherFrame = try! context?.fetch(descriptor).first
        
        let parModifier = otherFrame?.modifiers.first(where: {$0.name.elementsEqual("Par")})
        
        let teeBoxModifier = otherFrame?.modifiers.first(where: {$0.name.elementsEqual("Teebox")})
        
        let holeModifier = otherFrame?.modifiers.first(where: {$0.name.elementsEqual("Hole")})
        
        XCTAssert(otherFrame?.id == newFrame.id)
        XCTAssert(modifier.modifierType == parModifier?.modifierType)
        XCTAssert(modifier2.modifierType == teeBoxModifier?.modifierType)
        XCTAssert(modifier3.modifierType == holeModifier?.modifierType)
    }
    
    
    func testFrameWithGameHasGame() throws {
        let newFrame = Frame()
        context?.insert(newFrame)
        
        let newGame = Item()
        context!.insert(newGame)
        newFrame.game = newGame
        
        let descriptor = FetchDescriptor<Frame>()
        
        
        let otherFrame = try! context?.fetch(descriptor).first
        
        XCTAssert(otherFrame?.id == newFrame.id && newFrame.game?.id == newGame.id)
    }
    
    
    
    //GameTests
    
    func testEmptyGameCreation() throws {
        let newGame = Item()
        context?.insert(newGame)
        
        XCTAssert(context?.insertedModelsArray.count == 1 && context?.insertedModelsArray.first?.id == newGame.id)
    }
    
    func testGameCreatedWithFrameArrayHasFrames() throws {
        let newGame = Item()
        context!.insert(newGame)
        
        let frames = [Frame()]
        
        for frame in frames {
            context!.insert(frame)
            frame.game = newGame
            newGame.frames.append(frame)
        }
        
        let descriptor = FetchDescriptor<Item>()
        
        
        let otherGame = try! context?.fetch(descriptor).first
   
        XCTAssert(otherGame?.id == newGame.id && !newGame.frames.isEmpty)
    }
    
    func testGameCreatedWithPlayerArrayHasPlayers() throws {
        let newGame = Item()
        context!.insert(newGame)
        
        let players = [Player()]
        
        for player in players {
            context!.insert(player)
            player.games.append(newGame)
            newGame.players.append(player)
        }
        
        let descriptor = FetchDescriptor<Item>()
        
        
        let otherGame = try! context?.fetch(descriptor).first
        
        XCTAssert(otherGame?.id == newGame.id && !newGame.players.isEmpty)
    }
    
    func testGameCreatedWithBothPlayersAndFramesHasBoth() throws {
        let newGame = Item()
        context!.insert(newGame)
        
        let players = [Player()]
        let frames = [Frame()]
        
        for player in players {
            context!.insert(player)
            player.games.append(newGame)
            newGame.players.append(player)
        }
        
        for frame in frames {
            context!.insert(frame)
            frame.game = newGame
            newGame.frames.append(frame)
        }
        
        let descriptor = FetchDescriptor<Item>()
        
        
        let otherGame = try! context?.fetch(descriptor).first
        
        XCTAssert(otherGame?.id == newGame.id && !newGame.players.isEmpty && !newGame.frames.isEmpty)
    }
    
    func testGameWithPlayersAndFramesWhereFramesHasPlayers() throws {
        let newGame = Item()
        context!.insert(newGame)
        
        let players = [Player()]
        let frames = [Frame()]
        
        for player in players {
            context!.insert(player)
            player.games.append(newGame)
            newGame.players.append(player)
        }
        
        for frame in frames {
            context!.insert(frame)
            frame.game = newGame
            for player in players {
                frame.players.append(player)
            }
            newGame.frames.append(frame)
        }
        
        let descriptor = FetchDescriptor<Item>()
        
        
        let otherGame = try! context?.fetch(descriptor).first
        let framePlayer = newGame.frames.first?.players.first
        
        
        XCTAssert(otherGame?.id == newGame.id && framePlayer?.id == otherGame?.players.first?.id)
    }
    
    func testGameWithFrameAppendedAfterCreationHasExtraFrame() throws {
        let newGame = Item()
        context!.insert(newGame)
        
        let players = [Player()]
        let frames = [Frame()]
        
        for player in players {
            context!.insert(player)
            player.games.append(newGame)
            newGame.players.append(player)
        }
        
        for frame in frames {
            context!.insert(frame)
            frame.game = newGame
            newGame.frames.append(frame)
        }
        
        let initialCount = newGame.frames.count
        
        let newFrame = Frame()
        context!.insert(newFrame)
        newFrame.game = newGame
        newGame.frames.append(newFrame)
        
        
        let descriptor = FetchDescriptor<Item>()
        
        
        let otherGame = try! context?.fetch(descriptor).first
        
        let newCount = otherGame!.frames.count
        
        XCTAssert(otherGame?.id == newGame.id && newCount == initialCount + 1)
    }
    
    func testGameWithPlayersAndFramesWhereFramesHasPlayersAndScores() throws {
        let newGame = Item()
        context!.insert(newGame)
        
        let descriptor = FetchDescriptor<Item>()
        
        
        let otherGame = try! context?.fetch(descriptor).first
        
        XCTAssert(otherGame?.id == newGame.id)
        
        let players = [Player()]
        let frames = [Frame()]
        var scores = [Score]()
        
        var bufferScore : Score
        
        
        for player in players {
            context!.insert(player)
            
            bufferScore = Score()
            scores.append(bufferScore)
            context?.insert(bufferScore)
            
            bufferScore.player = player
            
            player.games.append(newGame)
            newGame.players.append(player)
        }
        
        XCTAssert(scores.first?.player?.id == players.first?.id)
        
        
        for frame in frames {
            
            context!.insert(frame)
            frame.game = newGame
            
            for player in players {
                frame.players.append(player)
            }
            for score in scores {
                frame.scores.append(score)
            }
            
            newGame.frames.append(frame)
        }
        
       
        let scorePlayer = newGame.frames.first?.scores.first?.player
        
        
        XCTAssert(scorePlayer?.id == otherGame?.players.first?.id && otherGame?.frames.first?.players.first?.id == scorePlayer?.id)
    }
    
    func testFullGameWithTieBreakEvent() throws {
        let newGame = Item()
        context!.insert(newGame)
        
        
        
        
        
        let players = [Player()]
        let frames = [Frame()]
        var scores = [Score]()
        
        var bufferScore : Score
        
        
        for player in players {
            context!.insert(player)
            
            bufferScore = Score()
            scores.append(bufferScore)
            context?.insert(bufferScore)
            
            bufferScore.player = player
            
            player.games.append(newGame)
            newGame.players.append(player)
        }
        
        for frame in frames {
            
            context!.insert(frame)
            frame.game = newGame
            
            for player in players {
                frame.players.append(player)
            }
            for score in scores {
                frame.scores.append(score)
            }
            
            newGame.frames.append(frame)
        }
        let initialCount = newGame.frames.count
        
        newGame.frames.first?.scores.first?.score = 2
        
        let newFrame = Frame()
        context?.insert(newFrame)
        newFrame.game = newGame
        newFrame.players = newGame.players
        
        for player in newFrame.players {
            
            bufferScore = Score()
            context?.insert(bufferScore)
            bufferScore.player = player
            newFrame.scores.append(bufferScore)
            
        }
        
        newGame.frames.append(newFrame)
        
        //game registers the new frame
        XCTAssert(newGame.frames.count == initialCount + 1)
        
        //the new frame has 1) scores set up, and 2) the new frame(and scores) properly represent the players
        XCTAssert(newGame.players.first?.id == newFrame.scores.first?.player?.id)
    }
    
    func testModifierCreation() throws {
        let modifier = Modifier(modifierType: .Arithmetic(value: 1), name: "Hole")
        context?.insert(modifier)
        
        XCTAssert(context?.insertedModelsArray.first?.id == modifier.id)
    }
    
    func testModifierHoldsCorrectIntegerValue() throws {
        let modifier = Modifier(modifierType: .Arithmetic(value: 1), name: "Hole")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType == modifier.modifierType)
        
    }
    
    func testModifierHoldsCorrectStringValue() throws {
        let modifier = Modifier(modifierType: .String(value: "Door"), name: "TeeBox")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType == modifier.modifierType)
        
    }
    
    func testModifierHoldsCorrectDoubleValue() throws {
        let modifier = Modifier(modifierType: .Double(value: 0.0), name: "Handicap")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType == modifier.modifierType)
        
    }
    
    func testStringModifierTypeCanCompareToLiteral() throws {
        let modifier = Modifier(modifierType: .String(value: "Door"), name: "TeeBox")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType == .String(value: "Door"))
        
    }
    
    func testIntModifierTypeCanCompareToLiteral() throws {
        let modifier = Modifier(modifierType: .Arithmetic(value: 1), name: "")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType == .Arithmetic(value: 1))
        
    }
    
    func testDoubleModifierTypeCanCompareToLiteral() throws {
        let modifier = Modifier(modifierType: .Double(value: 0.0), name: "")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType == .Double(value: 0.0))
        
    }
    
    func testModifiersOfIntAndDoubleAreNotEqual() throws {
        let modifier = Modifier(modifierType: .Arithmetic(value: 1), name: "")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType != .Double(value: 1.0))
        
    }
    
    func testModifiersOfIntAndIntAreNotEqual() throws {
        let modifier = Modifier(modifierType: .Arithmetic(value: 1), name: "")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType != .Arithmetic(value: 2))
        
    }
    
    func testModifiersOfStringAndIntAreNotEqual() throws {
        let modifier = Modifier(modifierType: .String(value: "1"), name: "")
        context?.insert(modifier)
        
        let descriptor = FetchDescriptor<Modifier>()
        
        
        let otherModifier = try! context?.fetch(descriptor).first
        
        XCTAssert(otherModifier?.modifierType != .Arithmetic(value: 1))
        
    }
    
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
