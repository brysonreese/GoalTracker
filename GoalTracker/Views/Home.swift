//
//  Home.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var store: GoalStore

    private var goals: [Goal] {
        store.goals.filter { $0.completed == false }.sorted(by: { lhs, rhs in
            lhs.goalDate < rhs.goalDate
        })
    }
    
    var body: some View {
        List{
            ForEach(goals) { (goal: Goal) in
                Text(goal.title)
            }
        }
    }
}

#Preview {
    Home().environmentObject(GoalStore())
}
