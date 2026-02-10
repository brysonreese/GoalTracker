//
//  Goal.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import Foundation
import Combine

class Goal: ObservableObject, Identifiable, Equatable, Codable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    @Published var title: String
    @Published var currentCount: Int
    @Published var targetCount: Int
    @Published var goalDate: Date
    @Published var completed: Bool
    
    init(id: UUID = UUID(), title: String, currentCount: Int, targetCount: Int, goalDate: Date, completed: Bool = false) {
        self.id = id
        self.title = title
        self.currentCount = currentCount
        self.targetCount = targetCount
        self.goalDate = goalDate
        self.completed = completed
    }

    // Codable conformance to handle @Published
    enum CodingKeys: String, CodingKey {
        case id, title, currentCount, targetCount, goalDate, completed
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        currentCount = try c.decode(Int.self, forKey: .currentCount)
        targetCount = try c.decode(Int.self, forKey: .targetCount)
        goalDate = try c.decode(Date.self, forKey: .goalDate)
        completed = try c.decode(Bool.self, forKey: .completed)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(currentCount, forKey: .currentCount)
        try c.encode(targetCount, forKey: .targetCount)
        try c.encode(goalDate, forKey: .goalDate)
        try c.encode(completed, forKey: .completed)
    }
    
    func increment() {
        if(currentCount < targetCount) {
            currentCount += 1
        }
    }
    
    func decrement() {
        if(currentCount > 0) {
            currentCount -= 1
        }
    }
    
    func complete() {
        if(completed == false){
            completed = true
        }
    }
    
    func uncomplete() {
        if(completed == true) {
            completed = false
        }
    }
}
