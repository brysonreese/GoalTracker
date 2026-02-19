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
        GoalGroupCard(goals: overdue, title: "Overdue")
    }
    
    @ViewBuilder
    private var dueTodayGoals: some View {
        let dueTodayGoals = store.dueTodayGoals()
        GoalGroupCard(goals: dueTodayGoals, title: "Due Today")
    }
    
    @ViewBuilder
    private var dueTomorrowGoals: some View {
        let tomorrowGoals = store.dueTomorrowGoals()
        GoalGroupCard(goals: tomorrowGoals, title: "Due Tomorrow")
    }
    
    @ViewBuilder
    private var dueLaterGoals: some View {
        let laterGoals = store.dueLaterGoals()
        GoalGroupCard(goals: laterGoals, title: "Due Later")
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
