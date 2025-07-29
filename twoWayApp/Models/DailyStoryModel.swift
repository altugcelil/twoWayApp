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

// MARK: - Ending Types (Hierarchical System)
enum EndingType: String, Codable, CaseIterable {
    // New Hierarchical System (Level 1-4, 1 = Best, 4 = Worst)
    case success = "success"           // Level 1: Perfect success, no cost
    case light_cost = "light_cost"     // Level 2: Success with minor cost
    case heavy_cost = "heavy_cost"     // Level 3: Survival with major cost
    case death = "death"               // Level 4: Character dies
    
    // Legacy types for backward compatibility
    case güvenli_başarısız = "güvenli_başarısız"     // Maps to: heavy_cost
    case erken_ölüm = "erken_ölüm"                   // Maps to: death
    case ölüm = "ölüm"                               // Maps to: death
    case suç_ortağı = "suç_ortağı"                   // Maps to: light_cost
    case kahraman = "kahraman"                       // Maps to: success
    case kahraman_bedelli = "kahraman_bedelli"       // Maps to: light_cost
    case süper_kahraman = "süper_kahraman"           // Maps to: success
    case good = "good"                               // Maps to: success
    case failure = "failure"                        // Maps to: heavy_cost
    case heroic = "heroic"                          // Maps to: success
    case compromise = "compromise"                   // Maps to: light_cost
    
    // Helper computed property for hierarchy level
    var hierarchyLevel: Int {
        switch self {
        case .success, .kahraman, .süper_kahraman, .good, .heroic:
            return 1 // Best
        case .light_cost, .kahraman_bedelli, .suç_ortağı, .compromise:
            return 2 // Light cost
        case .heavy_cost, .güvenli_başarısız, .failure:
            return 3 // Heavy cost
        case .death, .ölüm, .erken_ölüm:
            return 4 // Worst
        }
    }
    
    // Helper computed property for display name
    var displayName: String {
        switch self {
        case .success: return "Perfect Success"
        case .light_cost: return "Success with Minor Cost"
        case .heavy_cost: return "Survival with Major Cost"
        case .death: return "Death"
        // Legacy mappings
        case .kahraman, .süper_kahraman, .good, .heroic: return "Perfect Success"
        case .kahraman_bedelli, .suç_ortağı, .compromise: return "Success with Minor Cost"
        case .güvenli_başarısız, .failure: return "Survival with Major Cost"
        case .ölüm, .erken_ölüm: return "Death"
        }
    }
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