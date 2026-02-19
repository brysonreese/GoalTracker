//
//  GoalItemCompact.swift
//  GoalTracker
//
//  Created by Bryson Reese on 2/16/26.
//

import SwiftUI

struct GoalGroupCard: View {
    var goals: [Goal]
    var title: String
    var compact: Bool = true
    @State private var isExpanded = false
    
    var body: some View {
        let visibleGoals = isExpanded ? goals : Array(goals.prefix(3))

        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(compact ? .headline : .title3)
                Spacer()
                if goals.count > 3 {
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(compact ? .caption : .subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, compact ? 6 : 8)
                        .padding(.vertical, compact ? 2 : 4)
                        .background(.thinMaterial, in: Capsule())
                }
            }
            
            if goals.count > 0 {
                VStack(spacing: compact ? 6 : 8) {
                    ForEach(visibleGoals) { goal in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(goal.title)
                                    .font(compact ? .subheadline : .body)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                Text(goal.goalDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(compact ? .caption2 : .caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(goal.currentCount) / \(goal.targetCount)")
                                .font(compact ? .caption : .subheadline)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .padding(compact ? 8 : 12)
                        .background(
                            RoundedRectangle(cornerRadius: compact ? 8 : 12, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }
                }
            } else {
                Text("No Goals!")
                    .font(.body)
                    .fontWeight(.semibold)
            }

            if goals.count > 3 && !isExpanded {
                Text("+\(goals.count - 3) more")
                    .font(compact ? .caption2 : .caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(compact ? 12 : 16)
        .background(
            RoundedRectangle(cornerRadius: compact ? 12 : 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: compact ? 12 : 16, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06))
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                if goals.count > 3 {
                    isExpanded.toggle()
                }
            }
        }
    }
}

#Preview {
    let isoFormatter = ISO8601DateFormatter()
    let goal = Goal(title: "Test", currentCount: 0, targetCount: 10, goalDate: isoFormatter.date(from: "2026-02-09T12:00:00Z")!, frequency: .once)
    let goals = [goal, goal, goal, goal, goal]
    ScrollView {
        VStack(spacing: 16) {
            GoalGroupCard(goals: goals, title: "Compact Card", compact: true)
            GoalGroupCard(goals: goals, title: "Regular Card", compact: false)
            GoalGroupCard(goals: Array(goals.prefix(2)), title: "Compact Few", compact: true)
        }
        .padding()
    }
}
