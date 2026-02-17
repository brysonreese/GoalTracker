//
//  GoalItemCompact.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/16/26.
//

import SwiftUI

struct GoalItemCompact: View {
    @ObservedObject var goal: Goal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goal.title).font(.headline)
                Text(goal.goalDate.formatted(date: .abbreviated, time: .omitted)).font(.caption)
            }
            Spacer()
            Text("\(goal.currentCount) / \(goal.targetCount)")
        }
    }
}

#Preview {
    let isoFormatter = ISO8601DateFormatter()
    let goal = Goal(title: "Test", currentCount: 0, targetCount: 10, goalDate: isoFormatter.date(from: "2026-02-09T12:00:00Z")!, frequency: .once)
    GoalItemCompact(goal: goal)
}
