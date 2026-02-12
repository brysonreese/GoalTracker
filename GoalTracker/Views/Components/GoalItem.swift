//
//  GoalItem.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI

struct GoalItem: View {
    @ObservedObject var goal: Goal
    var allowEdit: Bool = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(goal.title).font(.title2)
                Text(goal.goalDate.formatted(date: .abbreviated, time: .omitted))
                Text(goal.frequency.rawValue.capitalized).font(.caption)
            }
            Spacer()
            
            Button {
                goal.decrement()
            } label: {
                Image(systemName: "minus.circle")
            }.disabled(!allowEdit)

            VStack {
                Text("\(goal.currentCount)")
                    .font(.title2)
                Text("\(goal.targetCount)")
                    .font(.caption)
            }
            Button {
                if(goal.currentCount < goal.targetCount) {
                    goal.increment()
                } else {
                    goal.complete()
                }
            } label: {
                if(goal.currentCount < goal.targetCount) {
                    Image(systemName: "plus.circle")
                } else {
                    Image(systemName: "checkmark.circle.fill")
                }
            }.disabled(!allowEdit)
        }.buttonStyle(.plain)
    }
}

#Preview {
    let isoFormatter = ISO8601DateFormatter()
    let goal = Goal(title: "Test", currentCount: 0, targetCount: 10, goalDate: isoFormatter.date(from: "2026-02-09T12:00:00Z")!, frequency: .once)
    GoalItem(goal: goal)
}
