//
//  Shell.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/9/26.
//

import SwiftUI
import Combine

struct Shell: View {
    @StateObject var goals = GoalStore()
    
    @AppStorage("goals_json") private var goalsJSON: String = ""
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Home()
            }
            Tab("Goals", systemImage: "star") {
                Goals().environmentObject(goals)
            }
        }
        .onAppear {
            // Load once when the app launches
            if !goalsJSON.isEmpty, let data = Data(base64Encoded: goalsJSON) {
                if let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
                    goals.goals = decoded
                }
            }
        }
        .onReceive(goals.objectWillChange) { _ in
            if let data = try? JSONEncoder().encode(goals.goals) {
                goalsJSON = data.base64EncodedString()
            }
        }
    }
}

#Preview {
    Shell()
}
