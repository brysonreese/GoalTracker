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
    
    enum Frequency: String, Codable {
        case once, daily, weekly, monthly
    }
    
    let id: UUID
    @Published var title: String
    @Published var currentCount: Int
    @Published var targetCount: Int
    @Published var goalDate: Date
    @Published var completed: Bool
    @Published var frequency: Frequency
    
    init(id: UUID = UUID(), title: String, currentCount: Int, targetCount: Int, goalDate: Date, completed: Bool = false, frequency: Frequency) {
        self.id = id
        self.title = title
        self.currentCount = currentCount
        self.targetCount = targetCount
        self.goalDate = goalDate
        self.completed = completed
        self.frequency = frequency
    }

    // Codable conformance to handle @Published
    enum CodingKeys: String, CodingKey {
        case id, title, currentCount, targetCount, goalDate, completed, frequency
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        currentCount = try c.decode(Int.self, forKey: .currentCount)
        targetCount = try c.decode(Int.self, forKey: .targetCount)
        goalDate = try c.decode(Date.self, forKey: .goalDate)
        completed = try c.decode(Bool.self, forKey: .completed)
        frequency = try c.decode(Frequency.self, forKey: .frequency)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(currentCount, forKey: .currentCount)
        try c.encode(targetCount, forKey: .targetCount)
        try c.encode(goalDate, forKey: .goalDate)
        try c.encode(completed, forKey: .completed)
        try c.encode(frequency, forKey: .frequency)
    }
    
    enum DueBucket: CaseIterable, Comparable {
        case pastDue
        case today
        case tomorrow
        case later
        case completed

        var title: String {
            switch self {
            case .pastDue: return "Past Due"
            case .today: return "Due Today"
            case .tomorrow: return "Due Tomorrow"
            case .later: return "Later"
            case .completed: return "Completed"
            }
        }

        // Define sort order of sections
        static func < (lhs: DueBucket, rhs: DueBucket) -> Bool {
            let order: [DueBucket] = [.pastDue, .today, .tomorrow, .later]
            return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
        }
    }

    private func bucket(for date: Date, calendar: Calendar = .current) -> DueBucket {
        let startOfToday = calendar.startOfDay(for: Date())
        
        if completed == true {
            return .completed
        }

        if date < startOfToday {
            return .pastDue
        }

        if calendar.isDate(date, inSameDayAs: startOfToday) {
            return .today
        }

        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday),
           calendar.isDate(date, inSameDayAs: tomorrow) {
            return .tomorrow
        }

        return .later
    }
    
    var dueBucket: DueBucket {
        bucket(for: goalDate)
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

