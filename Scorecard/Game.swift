//
//  Item.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//

import Foundation
import SwiftData



@Model
final class Game : Comparable{
    static func < (lhs: Game, rhs: Game) -> Bool {
        if(lhs.timestamp.timeIntervalSince(rhs.timestamp).isLess(than: 0.0)){
            return true
        }
        return false
    }
    
    @Relationship(.unique, inverse: \Frame.game) var frames : [Frame]
    @Relationship(.unique, inverse: \Player.games) var players : [Player]
    @Relationship var modifiers : [Modifier]
    
    let timestamp : Date = Date()
    var name : String = "Course Name"
    var descriptor : String = ""
    var isFinished : Bool = false
    var winner : String = ""
    var finalScoreString = ""
    
    init(frames : [Frame] = [Frame](), players : [Player] = [Player](), modifiers : [Modifier] = [Modifier]()) {
        self.players = players
        self.frames = frames
        self.modifiers = modifiers
    }
}

@Model
final class Frame : Comparable{
    static func < (lhs: Frame, rhs: Frame) -> Bool {
        if(lhs.holeNumber < rhs.holeNumber){
            return true
        }
        else {return false}
    }
    
    @Relationship var players : [Player]
    @Relationship(inverse: \Score.frame) var scores : [Score]
    @Relationship var modifiers : [Modifier]
    
    var game : Game?
    var holeNumber : Int
    
    
    init(holeNumber : Int = 0, players : [Player] = [], modifiers : [Modifier] = [], scores : [Score] = [], game : Game? = nil) {
        self.holeNumber = holeNumber
        self.modifiers = modifiers
        self.players = players
        self.scores = scores
        self.game = game
    }
}

@Model
final class Score{
    @Relationship var modifiers : [Modifier]
    
    var frame : Frame?
    var player : Player?
    var score : Int
    
    init(frame: Frame? = nil, player: Player? = nil, score: Int = 0, modifiers : [Modifier] = []) {
        self.frame = frame
        self.player = player
        self.score = score
        self.modifiers = modifiers
    }
}

@Model
final class Player : Identifiable{
    @Relationship var modifiers : [Modifier]
    
    
    var games : [Game]
    
    var name : String
  
    
    init(name: String = "PlayerName", games : [Game] = [], modifiers : [Modifier] = []) {
        self.name = name
        self.games = games
        self.modifiers = modifiers
    }
}

enum ModifierType: Codable, Equatable {
    case Arithmetic(value : Int)
    case String(value : String)
    case Double(value : Double)
}

@Model
final class Modifier : Equatable {
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
}

struct ModifierNames {
    static let teeboxPrototypeName = "teeboxPrototype"
    static let teeboxName = "teebox"
    static let holeName = "hole"
    static let parName = "par"
    static let frameModArray = [teeboxName, holeName, parName]
    
    
    static let averageStrokesPerHoleName = "avg strokes/hole"
    static let averageScorePerHoleName = "avg score/hole"
    static let averageScorePerGameName = "avg score/game"
    static let playerStatArray = [averageStrokesPerHoleName, averageScorePerHoleName, averageScorePerGameName]
        
}











//
//struct playerCollection{
//    typealias DictionaryType = [Player : Int]
//    
//    private var scores = DictionaryType()
//    
//    init(scores: DictionaryType) {
//        self.scores = scores
//    }
//}
//
//extension playerCollection : Collection {
//    typealias Index = DictionaryType.Index
//    typealias Element = DictionaryType.Element
//    
//    var startIndex: Index { return scores.startIndex }
//    var endIndex: Index { return scores.endIndex }
//    func index(after i: playerCollection.DictionaryType.Index) -> playerCollection.DictionaryType.Index {
//            return scores.index(after: i)
//        }
//    
//    subscript(index: Index) -> Iterator.Element {
//            get { return scores[index] }
//        }
//    subscript(player: Player) -> Int {
//           get { return scores[player] ?? 0 }
//           set { scores[player] = newValue }
//       }
//    
//}
