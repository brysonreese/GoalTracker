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
    @State private var goalToEdit: Goal? = nil
    
    private var goals: [Goal] {
        store.goals.filter { $0.completed == false }.sorted(by: { lhs, rhs in
            lhs.goalDate < rhs.goalDate
        })
    }
    
    private var groupedSections: [(title: String, items: [Goal])] {
        let grouped = Dictionary(grouping: goals) { $0.dueBucket }
        let sortedKeys = grouped.keys.sorted()
        return sortedKeys.map { key in
            (title: key.title, items: grouped[key] ?? [])
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Goals",
            systemImage: "plus.circle",
            description: Text("Add a goal to get started!")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func goalsList(sections: [(title: String, items: [Goal])]) -> some View {
        List {
            ForEach(sections, id: \.title) { section in
                sectionView(section)
            }
        }
    }
    
    @ViewBuilder
    private func sectionView(_ section: (title: String, items: [Goal])) -> some View {
        Section(header: Text(section.title)) {
            ForEach(section.items) { (goal: Goal) in
                goalRow(goal)
            }
        }
    }
    
    @ViewBuilder
    private func goalRow(_ goal: Goal) -> some View {
        Button {
            goalToEdit = goal
        } label: {
            GoalItem(goal: goal)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                store.deleteGoal(goal)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            let isEmpty = goals.isEmpty
            let sections = groupedSections

            Group {
                if isEmpty {
                    emptyStateView
                } else {
                    goalsList(sections: sections)
                }
            }
            .navigationTitle(Text("Goals"))
            .toolbar {
                leadingToolbar
                trailingToolbar
            }
        }
        .sheet(item: $goalToEdit) { goal in
            EditGoal(goal: goal)
                .environmentObject(store)
        }
    }
    
    @ToolbarContentBuilder
    private var leadingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { showCompletedGoals.toggle() }) {
                Image(systemName: "checkmark.seal")
                Text("Completed")
            }
            .sheet(isPresented: $showCompletedGoals) {
                CompletedGoals().environmentObject(store)
            }
        }
    }

    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { showAddGoal.toggle() }) {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $showAddGoal) {
                EditGoal().environmentObject(store)
            }
        }
    }
}



#Preview {
    Goals().environmentObject(GoalStore())
}
