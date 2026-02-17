//
//  Home.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var store: GoalStore
    
    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good morning!"
        case 12..<18:
            return "Good afternoon!"
        default:
            return "Good evening!"
        }
    }
    
    @ViewBuilder
    private var overdueGoals: some View {
        let overdue = store.overdueGoals()
        if overdue.isEmpty {
            EmptyView()
        } else {
            goalList(goals: overdue, header: "Overdue")
        }
    }
    
    @ViewBuilder
    private var dueTodayGoals: some View {
        let dueTodayGoals = store.dueTodayGoals()
        if dueTodayGoals.isEmpty {
            EmptyView()
        } else {
            goalList(goals: dueTodayGoals, header: "Due Today")
        }
    }
    
    @ViewBuilder
    private var dueTomorrowGoals: some View {
        let tomorrowGoals = store.dueTomorrowGoals()
        if tomorrowGoals.isEmpty {
            EmptyView()
        } else {
            goalList(goals: tomorrowGoals, header: "Due Tomorrow")
        }
    }
    
    @ViewBuilder
    private var dueLaterGoals: some View {
        let laterGoals = store.dueLaterGoals()
        if laterGoals.isEmpty {
            EmptyView()
        } else {
            goalList(goals: laterGoals, header: "Due Later")
        }
    }
    
    @ViewBuilder
    private func goalList(goals: [Goal], header: String) -> some View {
        Section(header: Text(header)) {
            ForEach(goals) { goal in
                GoalItemCompact(goal: goal)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 0.5) {
                List {
                    overdueGoals
                    dueTodayGoals
                    dueTomorrowGoals
                    dueLaterGoals
                }
            }.navigationTitle(greeting())
        }
    }
}

#Preview {
    Home().environmentObject(GoalStore())
}
