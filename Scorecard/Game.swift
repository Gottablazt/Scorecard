//
//  Item.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//  MVP 0.0.1 10/3/24

import Foundation
import SwiftData

//I AM UNSURE WHAT .UNIQUE DOES


@Model
final class Game : Comparable{
    
    //required function for Comparable
    static func < (lhs: Game, rhs: Game) -> Bool {
        if(lhs.timestamp.timeIntervalSince(rhs.timestamp).isLess(than: 0.0)){
            return true
        }
        return false
    }
    @Relationship var course : Course?
    //game has frames
    @Relationship(.unique, inverse: \Frame.game) var frames : [Frame]
    //game has players
    @Relationship(.unique, inverse: \Player.games) var players : [Player]
    //game has modifiers
    @Relationship var modifiers : [GameModifier]
    
    
    let timestamp : Date = Date()
    var descriptor : String = ""//could be a modifier
    var isFinished : Bool = false//could be a modifier
    var winner : String = ""//could be a modifier
    var finalScoreString = ""//could be a modifier
    
    init(frames : [Frame] = [Frame](), players : [Player] = [Player](), modifiers : [GameModifier] = [GameModifier](), course : Course? = nil) {
        self.players = players
        self.frames = frames
        self.modifiers = modifiers
        self.course = course
    }
}

@Model
final class Course : Comparable{
    
    static func < (lhs: Course, rhs: Course) -> Bool {
        if(lhs.timestamp.timeIntervalSince(rhs.timestamp).isLess(than: 0.0)){
            return true
        }
        return false
    }
    @Relationship(.unique, inverse: \Frame.course) var frames : [Frame]
    @Relationship var modifiers : [CourseModifier]
    
    let timestamp : Date = Date()
    var descriptor : String = ""//could be a modifier
    var name : String = ""
    
    init(frames : [Frame] = [Frame](), modifiers : [CourseModifier] = [CourseModifier]()) {
        self.frames = frames
        self.modifiers = modifiers
    }
}

@Model
final class Frame : Comparable{
    //required function for Comparable
    static func < (lhs: Frame, rhs: Frame) -> Bool {
        if(lhs.holeNumber < rhs.holeNumber){
            return true
        }
        else {return false}
    }
    //game has players
    @Relationship var players : [Player]
    //game has score
    @Relationship(inverse: \Score.frame) var scores : [Score]
    //game has modifiers
    @Relationship var modifiers : [FrameModifier]
    
    //inverse
    var game : Game?
    var course : Course?
    var holeNumber : Int
    
    
    init(holeNumber : Int = 0, players : [Player] = [], modifiers : [FrameModifier] = [], scores : [Score] = [], game : Game? = nil, course : Course? = nil) {
        self.holeNumber = holeNumber
        self.modifiers = modifiers
        self.players = players
        self.scores = scores
        self.game = game
        self.course = course
    }
    
}

@Model
final class Score : Comparable{
    static func < (lhs: Score, rhs: Score) -> Bool {
        if ((lhs.player?.name.first?.asciiValue!)! > (rhs.player?.name.first?.asciiValue!)!){
            return true
        }
        return false
    }
    
    //score has modifiers(currently unused)
    @Relationship var modifiers : [ScoreModifier]
    
    var frame : Frame?
    var player : Player?
    var score : Int
    
    init(frame: Frame? = nil, player: Player? = nil, score: Int = 0, modifiers : [ScoreModifier] = []) {
        self.frame = frame
        self.player = player
        self.score = score
        self.modifiers = modifiers
    }
    
}

@Model
final class Player : Identifiable, Comparable{
    static func < (lhs: Player, rhs: Player) -> Bool {
        if((lhs.name.first?.asciiValue!)! > (lhs.name.first?.asciiValue!)!){
            return true
        }
        return false
    }
    
    
    //player has modifiers
    @Relationship var modifiers : [PlayerModifier]
    
    var games : [Game]
    
    var name : String
  
    
    init(name: String = "PlayerName", games : [Game] = [], modifiers : [PlayerModifier] = []) {
        self.name = name
        self.games = games
        self.modifiers = modifiers
    }
    
}

class Modifier : Equatable {
    
    static func == (lhs: Modifier, rhs: Modifier) -> Bool {
        if(lhs.name == rhs.name){
            if(lhs.modifierType == rhs.modifierType){
                return true
            }
        }
        return false
    }
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
    
}

@Model
final class GameModifier : Equatable {
    
    static func == (lhs: GameModifier, rhs: GameModifier) -> Bool {
        if(lhs.name == rhs.name){
            if(lhs.modifierType == rhs.modifierType){
                return true
            }
        }
        return false
    }
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
    
}

@Model
final class FrameModifier : Equatable {
    
    static func == (lhs: FrameModifier, rhs: FrameModifier) -> Bool {
        if(lhs.name == rhs.name){
            if(lhs.modifierType == rhs.modifierType){
                return true
            }
        }
        return false
    }
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
    
}

@Model
final class PlayerModifier : Equatable {
    
    static func == (lhs: PlayerModifier, rhs: PlayerModifier) -> Bool {
        if(lhs.name == rhs.name){
            if(lhs.modifierType == rhs.modifierType){
                return true
            }
        }
        return false
    }
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
    
}

@Model
final class ScoreModifier : Equatable {
    
    static func == (lhs: ScoreModifier, rhs: ScoreModifier) -> Bool {
        if(lhs.name == rhs.name){
            if(lhs.modifierType == rhs.modifierType){
                return true
            }
        }
        return false
    }
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
    
}

@Model
final class CourseModifier : Equatable {
    
    static func == (lhs: CourseModifier, rhs: CourseModifier) -> Bool {
        if(lhs.name == rhs.name){
            if(lhs.modifierType == rhs.modifierType){
                return true
            }
        }
        return false
    }
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
    
}

enum ModifierType: Codable, Equatable, Hashable {
    case Arithmetic(value : Int)
    case String(value : String)
    case Double(value : Double)
    case Bool(value : Bool)
}


struct FrameModifierNames {
    static let teeboxPrototypeName = "teeboxPrototype"
    static let teeboxName = "teebox"
    static let holeName = "hole"
    static let parName = "par"
    static let frameModArray = [
        teeboxName,
        holeName,
        parName
    ]
}

struct PlayerModifierNames{
    static let averageStrokesPerHoleName = "avg strokes/hole"
    static let plusMinus = "Plus-Minus"
    static let handicap = "handicap"
    static let averageStrokesPerFrame = "avg strokes/frame"
    static let averageScorePerGameName = "avg score/game"
    static let averageStrokesPerTeebox = "avg score/teebox"
    static let averageStrokesPerTeeShot = "avg strokes/teeshot"
    static let averageStrokesPerApproach = "avg strokes/approach"
    static let averageChipsPerHole = "avg chips/hole"
    static let averagePuttsPerHole = "avg putts/hole"
    static let averageHazardsPerHole = "avg haz/hole"
    static let playerStatArray = [
        averageStrokesPerHoleName,
        plusMinus,
        averageScorePerGameName
    ]
}

struct ScoreModifierNames{
    static let teeShotName = "teeShot"
    static let approachName = "approach"
    static let chipsName = "chips"
    static let puttsName = "putts"
    static let hazardsName = "hazard"
    static let scoreModArray = [
        teeShotName,
        approachName,
        chipsName,
        puttsName,
        hazardsName
    ]
}

struct GameModifierNames{
    
}
