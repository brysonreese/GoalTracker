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
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    TextField("Title", text: $title).padding()
                    Stepper(value: $targetCount, in: 0...1000) {
                        Text("Target Count: \(targetCount)")
                    }.padding()
                    DatePicker("Goal Date", selection: $goalDate, displayedComponents: [.date]).padding()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            if(!title.isEmpty && targetCount > 0) {
                                store.addGoal(title: title, target: targetCount, goalDate: goalDate)
                                dismiss()
                            }
                        }) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddGoal()
}
