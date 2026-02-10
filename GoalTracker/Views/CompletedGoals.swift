//
//  CompletedGoals.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/10/26.
//

import SwiftUI

struct CompletedGoals: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: GoalStore
    
    var body: some View {
        List {
            ForEach(store.goals.filter { $0.completed == true }.sorted(by: { b, a in
                a.goalDate < b.goalDate
            })) { goal in
                GoalItem(goal: goal)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            store.deleteGoal(goal)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button() {
                            goal.uncomplete()
                        } label: {
                            Label("Uncomplete", systemImage: "xmark.circle")
                        }
                    }
            }
        }.navigationTitle(Text("Completed Goals"))
    }
}
