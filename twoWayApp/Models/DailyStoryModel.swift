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
    let imageUrl: String?               // Firebase Storage'dan görsel URL'i
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

// MARK: - Ending Types (Universal Hierarchy System)
enum EndingType: String, Codable, CaseIterable {
    // New Universal Hierarchy System (Level 1-4, 1 = Best, 4 = Worst)
    case perfect = "perfect"         // Level 1: Perfect outcome, no issues
    case good = "good"              // Level 2: Good outcome with minor issues  
    case poor = "poor"              // Level 3: Poor outcome with major issues
    case worst = "worst"            // Level 4: Worst possible outcome
    
    // Legacy types for backward compatibility (Survival theme)
    case success = "success"                     // Maps to: perfect
    case light_cost = "light_cost"               // Maps to: good
    case heavy_cost = "heavy_cost"               // Maps to: poor  
    case death = "death"                         // Maps to: worst
    case güvenli_başarısız = "güvenli_başarısız" // Maps to: poor
    case erken_ölüm = "erken_ölüm"               // Maps to: worst
    case ölüm = "ölüm"                           // Maps to: worst
    case suç_ortağı = "suç_ortağı"               // Maps to: good
    case kahraman = "kahraman"                   // Maps to: perfect
    case kahraman_bedelli = "kahraman_bedelli"   // Maps to: good
    case süper_kahraman = "süper_kahraman"       // Maps to: perfect
    case failure = "failure"                     // Maps to: poor
    case heroic = "heroic"                       // Maps to: perfect
    case compromise = "compromise"               // Maps to: good
    
    // Helper computed property for hierarchy level
    var hierarchyLevel: Int {
        switch self {
        case .perfect, .success, .kahraman, .süper_kahraman, .heroic:
            return 1 // Best
        case .good, .light_cost, .kahraman_bedelli, .suç_ortağı, .compromise:
            return 2 // Good with minor issues
        case .poor, .heavy_cost, .güvenli_başarısız, .failure:
            return 3 // Poor with major issues
        case .worst, .death, .ölüm, .erken_ölüm:
            return 4 // Worst
        }
    }
    
    // Helper computed property for display name
    var displayName: String {
        switch self {
        case .perfect: return "Perfect Outcome"
        case .good: return "Good Outcome"  
        case .poor: return "Poor Outcome"
        case .worst: return "Worst Outcome"
        // Legacy mappings
        case .success, .kahraman, .süper_kahraman, .heroic: return "Perfect Outcome"
        case .light_cost, .kahraman_bedelli, .suç_ortağı, .compromise: return "Good Outcome"
        case .heavy_cost, .güvenli_başarısız, .failure: return "Poor Outcome"
        case .death, .ölüm, .erken_ölüm: return "Worst Outcome"
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