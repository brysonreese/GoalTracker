//
//  AddForm.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI

struct AddGoal: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: GoalStore
    @State private var title: String = ""
    @State private var targetCount: Int = 0
    @State private var goalDate: Date = Date()
    @State private var frequency: Goal.Frequency = .once
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    TextField("Title", text: $title).padding(.bottom)
                    Stepper(value: $targetCount, in: 0...1000) {
                        Text("Target Count: \(targetCount)")
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
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.backward")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            if(!title.isEmpty && targetCount > 0) {
                                store.addGoal(title: title, target: targetCount, goalDate: goalDate, frequency: frequency)
                                dismiss()
                            }
                        }) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }.navigationTitle("Add Goal")
        }
    }
}

#Preview {
    AddGoal()
}
