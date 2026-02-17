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
    
    private var completedGoals: [Goal] {
        store.goals
            .filter { $0.completed }
            .sorted(by: { lhs, rhs in
                lhs.goalDate > rhs.goalDate
            })
    }

    var body: some View {
        NavigationStack {
            if completedGoals.isEmpty {
                ContentUnavailableView("No Completed Goals", systemImage: "checkmark.circle")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "arrow.backward")
                            }
                        }
                    }
            } else {
                List {
                    ForEach(completedGoals) { goal in
                        GoalItem(goal: goal, allowEdit: false)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    store.deleteGoal(goal)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    goal.uncomplete()
                                } label: {
                                    Label("Uncomplete", systemImage: "xmark.circle")
                                }
                            }
                    }
                }.navigationTitle("Completed Goals")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.backward")
                        }
                    }
                }
            }
        }
    }
}
