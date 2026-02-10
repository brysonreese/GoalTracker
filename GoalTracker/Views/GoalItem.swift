//
//  GoalItem.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI

struct GoalItem: View {
    @ObservedObject var goal: Goal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(goal.title)
                Text(goal.goalDate.formatted(date: .abbreviated, time: .omitted))
            }
            Spacer()
            
            Button {
                goal.decrement()
            } label: {
                Image(systemName: "minus.circle.fill")
            }
            Text("\(goal.currentCount)/\(goal.targetCount)")
            Button {
                if(goal.currentCount < goal.targetCount) {
                    goal.increment()
                } else {
                    goal.complete()
                }
            } label: {
                if(goal.currentCount < goal.targetCount) {
                    Image(systemName: "plus.circle.fill")
                } else {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
        }
        .buttonStyle(.bordered)
        .contentShape(Rectangle())
    }
}

#Preview {
    let isoFormatter = ISO8601DateFormatter()
    let goal = Goal(title: "Test", currentCount: 0, targetCount: 10, goalDate: isoFormatter.date(from: "2026-02-09T12:00:00Z")!)
    GoalItem(goal: goal)
}
