//
//  DailyStoryModel.swift
//  twoWayApp
//
//  Created by Berkut Teknoloji on 28.07.2025.
//

import Foundation

// MARK: - Daily Story (Firebase'ten gelecek)
struct DailyStory: Codable {
    let date: String                    // "2025-01-28"
    let title: String                   // "Gece Vardiyası"
    let estimatedDuration: String       // "8-15 dk"
    let genre: String                   // "Gerilim"
    let startNodeId: String
    let nodes: [String: StoryNode]
    
    // Basit validation
    func isValid() -> Bool {
        return nodes[startNodeId] != nil
    }
}

// MARK: - Story Node (Flexible - farklı seçenek sayıları)
struct StoryNode: Codable {
    let id: String
    let text: String                    // Ana hikaye metni
    let choices: [Choice]?              // nil = ending node
    let ending: StoryEnding?            // non-nil = ending node
    
    var isEnding: Bool {
        return ending != nil
    }
}

// MARK: - Choice (2-4 seçenek olabilir)
struct Choice: Codable {
    let id: String
    let text: String
    let targetNodeId: String?           // nil = instant ending
    let instantEnding: StoryEnding?     // Anında bitiş için
}

// MARK: - Story Ending (Basit)
struct StoryEnding: Codable {
    let title: String                   // "Kahraman"
    let description: String             // Ending açıklaması
    let type: EndingType                // success, failure, death, etc.
}

// MARK: - Ending Types
enum EndingType: String, Codable, CaseIterable {
    case güvenli_başarısız = "güvenli_başarısız"
    case erken_ölüm = "erken_ölüm"
    case ölüm = "ölüm"
    case suç_ortağı = "suç_ortağı"
    case kahraman = "kahraman"
    case kahraman_bedelli = "kahraman_bedelli"
    case süper_kahraman = "süper_kahraman"
    
    // Legacy types for backward compatibility
    case good = "good"
    case success = "success"
    case failure = "failure"
    case death = "death"
    case heroic = "heroic"
    case compromise = "compromise"
}

// MARK: - Game State (Basit)
enum GameState {
    case loading
    case playing
    case finished
    case error
}

// MARK: - Player Progress (Minimal)
struct GameProgress {
    var currentNodeId: String = ""
    var choicesMade: Int = 0
    var isCompleted: Bool = false
    var completedAt: Date?
    var finalEnding: StoryEnding?
} 