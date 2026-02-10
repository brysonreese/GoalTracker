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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.goals.filter { $0.completed == false }.sorted(by: { a, b in
                    a.goalDate < b.goalDate
                })) { goal in
                    GoalItem(goal: goal)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                store.deleteGoal(goal)
                            } label: {
                                Label("Delete", systemImage: "trash")
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
