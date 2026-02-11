//
//  GoalStore.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import Foundation
import Combine

class GoalStore: ObservableObject {
    
    @Published var goals: [Goal] = [] {
        didSet { bindToGoals() }
    }

    private var cancellables: Set<AnyCancellable> = []
    private var goalCancellables: [UUID: AnyCancellable] = [:]

    private func bindToGoals() {
        // Remove subscriptions for removed goals
        let currentIDs = Set(goals.map { $0.id })
        for (id, cancellable) in goalCancellables where !currentIDs.contains(id) {
            cancellable.cancel()
            goalCancellables.removeValue(forKey: id)
        }

        // Subscribe to new goals
        for goal in goals where goalCancellables[goal.id] == nil {
            let c = goal.objectWillChange
                .sink { [weak self] _ in
                    // Forward each goal’s change to the store so SwiftUI updates
                    self?.objectWillChange.send()
                }
            goalCancellables[goal.id] = c
        }
    }
    
    func getIndex(for goal: Goal) -> Int? {
        goals.firstIndex(of: goal)
    }
    
    func addGoal(title: String, target: Int, goalDate: Date, frequency: Goal.Frequency) {
        let newGoal = Goal(title: title, currentCount: 0, targetCount: target, goalDate: goalDate, frequency: frequency)
        goals.append(newGoal)
    }
    
    func deleteGoal(_ goal: Goal) {
        guard let index = getIndex(for: goal) else { return }
        
        goals.remove(at: index)
    }
}
