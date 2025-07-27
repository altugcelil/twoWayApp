//
//  DailyStoryService.swift
//  twoWayApp
//
//  Created by Berkut Teknoloji on 28.07.2025.
//

import Foundation
import FirebaseFirestore

// MARK: - Daily Story Service
class DailyStoryService: ObservableObject {
    
    static let shared = DailyStoryService()
    
    private let db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    
    @Published var isLoading = false
    @Published var error: StoryError?
    
    private init() {}
    
    // MARK: - Today's Story
    
    /// Bugünün hikayesini Firebase'ten çek
    func fetchTodaysStory(completion: @escaping (Result<DailyStory, StoryError>) -> Void) {
        let todayString = getTodayString()
        
        print("🔍 Aranan tarih: \(todayString)")
        
        isLoading = true
        error = nil
        
        db.collection("daily_stories")
            .document(todayString)
            .getDocument { [weak self] document, error in
                
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        print("🔥 Firebase network error: \(error.localizedDescription)")
                        let storyError = StoryError.networkError(error.localizedDescription)
                        self?.error = storyError
                        completion(.failure(storyError))
                        return
                    }
                    
                    guard let document = document else {
                        print("❌ Document is nil")
                        let storyError = StoryError.noStoryForToday
                        self?.error = storyError
                        completion(.failure(storyError))
                        return
                    }
                    
                    print("📄 Document exists: \(document.exists)")
                    print("📄 Document data: \(document.data() ?? [:])")
                    
                    guard document.exists, let data = document.data() else {
                        print("❌ Document doesn't exist or no data")
                        let storyError = StoryError.noStoryForToday
                        self?.error = storyError
                        completion(.failure(storyError))
                        return
                    }
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let story = try JSONDecoder().decode(DailyStory.self, from: jsonData)
                        
                        // Validation
                        guard story.isValid() else {
                            print("❌ Story validation failed")
                            let storyError = StoryError.invalidStory
                            self?.error = storyError
                            completion(.failure(storyError))
                            return
                        }
                        
                        print("✅ Story loaded successfully: \(story.title)")
                        completion(.success(story))
                        
                    } catch {
                        print("❌ JSON decode error: \(error)")
                        let storyError = StoryError.decodingError(error.localizedDescription)
                        self?.error = storyError
                        completion(.failure(storyError))
                    }
                }
            }
    }
    
    // MARK: - Story Completion Tracking
    
    /// Bugünün hikayesi tamamlandı mı?
    func isTodaysStoryCompleted() -> Bool {
        let todayString = getTodayString()
        return userDefaults.bool(forKey: "completed_\(todayString)")
    }
    
    /// Bugünün hikayesini tamamlandı olarak işaretle
    func markTodaysStoryCompleted() {
        let todayString = getTodayString()
        userDefaults.set(true, forKey: "completed_\(todayString)")
        userDefaults.set(Date(), forKey: "completed_at_\(todayString)")
    }
    
    /// Bugünün hikayesi tamamlandığında ne zaman bitirildi?
    func getTodaysCompletionTime() -> Date? {
        let todayString = getTodayString()
        return userDefaults.object(forKey: "completed_at_\(todayString)") as? Date
    }
    
    // MARK: - Helper Methods
    
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    /// Test için manuel tarih
    func getStoryForDate(_ date: String, completion: @escaping (Result<DailyStory, StoryError>) -> Void) {
        isLoading = true
        error = nil
        
        db.collection("daily_stories")
            .document(date)
            .getDocument { [weak self] document, error in
                
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        let storyError = StoryError.networkError(error.localizedDescription)
                        self?.error = storyError
                        completion(.failure(storyError))
                        return
                    }
                    
                    guard let document = document,
                          document.exists,
                          let data = document.data() else {
                        let storyError = StoryError.noStoryForDate(date)
                        self?.error = storyError
                        completion(.failure(storyError))
                        return
                    }
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let story = try JSONDecoder().decode(DailyStory.self, from: jsonData)
                        
                        guard story.isValid() else {
                            let storyError = StoryError.invalidStory
                            self?.error = storyError
                            completion(.failure(storyError))
                            return
                        }
                        
                        completion(.success(story))
                        
                    } catch {
                        let storyError = StoryError.decodingError(error.localizedDescription)
                        self?.error = storyError
                        completion(.failure(storyError))
                    }
                }
            }
    }
}

// MARK: - Story Errors
enum StoryError: Error, LocalizedError {
    case networkError(String)
    case noStoryForToday
    case noStoryForDate(String)
    case invalidStory
    case decodingError(String)
    case alreadyCompleted
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Ağ hatası: \(message)"
        case .noStoryForToday:
            return "Bugün için hikaye bulunamadı"
        case .noStoryForDate(let date):
            return "\(date) için hikaye bulunamadı"
        case .invalidStory:
            return "Hikaye formatı geçersiz"
        case .decodingError(let message):
            return "Hikaye okunamadı: \(message)"
        case .alreadyCompleted:
            return "Bu hikayeyi zaten tamamladınız"
        }
    }
} 