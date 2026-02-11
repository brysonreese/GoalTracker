//
//  Goals.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI

struct Goals: View {
    @EnvironmentObject private var store: GoalStore
    @State private var showAddGoal: Bool = false
    @State private var showCompletedGoals: Bool = false
    
    private var goals: [Goal] {
        store.goals.filter { $0.completed == false }.sorted(by: { lhs, rhs in
            lhs.goalDate < rhs.goalDate
        })
    }
    
    var body: some View {
        NavigationStack {
            Group{
                if(goals.isEmpty) {
                    ContentUnavailableView("No Goals", systemImage: "plus.circle", description: Text("Add a goal to get started!"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(goals) { goal in
                            GoalItem(goal: goal)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        store.deleteGoal(goal)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }.navigationTitle(Text("Goals"))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            showCompletedGoals.toggle()
                        }) {
                            Image(systemName: "checkmark.seal")
                            Text("Completed")
                        }.sheet(isPresented: $showCompletedGoals, content: {
                            CompletedGoals().environmentObject(store)
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showAddGoal.toggle()
                        }) {
                            Image(systemName: "plus")
                        }.sheet(isPresented: $showAddGoal, content: {
                            AddGoal().environmentObject(store)
                        })
                    }
                }
        }

    }
}

#Preview {
    Goals().environmentObject(GoalStore())
}
