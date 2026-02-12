//
//  AddForm.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI

struct EditGoal: View {
    let goal: Goal?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: GoalStore
    @State private var title: String
    @State private var targetCount: Int
    @State private var goalDate: Date
    @State private var frequency: Goal.Frequency
    
    private var isEditing: Bool { goal != nil }
    
    private var navTitle: String { isEditing ? "Edit Goal" : "Add Goal" }
    
    private var canSave: Bool { !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && targetCount > 0 }
    
    init(goal: Goal? = nil) {
        self.title = goal?.title ?? ""
        self.targetCount = goal?.targetCount ?? 0
        self.goalDate = goal?.goalDate ?? Date()
        self.frequency = goal?.frequency ?? Goal.Frequency.once
        self.goal = goal
    }
    
    @ViewBuilder
    private var formContent: some View {
        Form {
            VStack(alignment: .leading) {
                TextField("Title", text: $title).padding(.bottom)
                Stepper(value: $targetCount, in: 0...1000) {
                    Text("Target: \(targetCount)")
                }.padding(.bottom)
                DatePicker("Goal Date", selection: $goalDate, displayedComponents: [.date]).padding(.bottom)
                Picker("Frequency", selection: $frequency) {
                    Text("Once").tag(Goal.Frequency.once)
                    Text("Daily").tag(Goal.Frequency.daily)
                    Text("Weekly").tag(Goal.Frequency.weekly)
                    Text("Monthly").tag(Goal.Frequency.monthly)
                }
            }
            .toolbar {
                leadingToolbar
                trailingToolbar
            }
        }
    }
    
    var body: some View {
        NavigationView {
            formContent
                .navigationTitle(navTitle).navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    @ToolbarContentBuilder
    private var leadingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.backward")
            }
        }
    }
    
    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                guard canSave else { return }
                if isEditing, let goal = goal {
                    store.updateGoal(goal: goal, title: title, target: targetCount, goalDate: goalDate, frequency: frequency)
                } else {
                    store.addGoal(title: title, target: targetCount, goalDate: goalDate, frequency: frequency)
                }
                dismiss()
            }) {
                Image(systemName: "checkmark")
            }
        }
    }
}

#Preview {
    EditGoal(goal: nil)
        .environmentObject(GoalStore())
}
