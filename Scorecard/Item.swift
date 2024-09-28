//
//  Item.swift
//  Scorecard
//
//  Created by Brett Garon on 8/28/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    @Relationship(.unique, inverse: \Frame.game) var frames : [Frame]
    @Relationship(.unique, inverse: \Player.games) var players : [Player]
    let timestamp : Date = Date()
    var descriptor : String = ""
    var isFinished : Bool = false
    var winner : String = ""
    var finalScoreString = ""
    init(frames : [Frame] = [Frame](), players : [Player] = [Player]()) {
        self.players = players
        self.frames = frames
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
    
    var game : Item?
    var holeNumber : Int
    
    
    init(holeNumber : Int = 0, players : [Player] = [], modifiers : [Modifier] = [], scores : [Score] = [], game : Item? = nil) {
        self.holeNumber = holeNumber
        self.modifiers = modifiers
        self.players = players
        self.scores = scores
        self.game = game
    }
}

@Model
final class Score{
    
    var frame : Frame?
    var player : Player?
    var score : Int
    
    init(frame: Frame? = nil, player: Player? = nil, score: Int = 0) {
        self.frame = frame
        self.player = player
        self.score = score
    }
}

@Model
final class Player : Identifiable{
    
    var games : [Item]
    
    var name : String
  
    
    init(name: String = "PlayerName", games : [Item] = []) {
        self.name = name
        self.games = games
        
    }
}
enum ModifierType: Codable, Equatable {
    case Arithmetic(value : Int)
    case String(value : String)
    case Double(value : Double)
}

@Model
final class Modifier {
    static let teeboxName = "Teebox"
    static let parName = "Par"
    static let holeName = "Hole"
    
    
    
    var modifierType : ModifierType
    var name : String
    
    init(modifierType: ModifierType, name : String) {
        self.modifierType = modifierType
        self.name = name
    }
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
