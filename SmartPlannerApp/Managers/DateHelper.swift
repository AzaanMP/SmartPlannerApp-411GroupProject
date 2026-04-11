//
//  DateHelper.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation

class DateHelper {
    // We use a 'static' function so we can use this math anywhere in the app without creating a new DateHelper object every time.
    static func generateMilestones(for title: String, finalDate: Date) -> [Milestone] {
        let calendar = Calendar.current
        var milestones: [Milestone] = []
        
        // Task 1: Outline (5 days before)
        if let outlineDate = calendar.date(byAdding: .day, value: -5, to: finalDate) {
            milestones.append(Milestone(title: "Outline: \(title)", dueDate: outlineDate))
        }
        
        // Task 2: Draft (3 days before)
        if let draftDate = calendar.date(byAdding: .day, value: -3, to: finalDate) {
            milestones.append(Milestone(title: "Draft: \(title)", dueDate: draftDate))
        }
        
        // Task 3: Final Review (1 day before)
        if let reviewDate = calendar.date(byAdding: .day, value: -1, to: finalDate) {
            milestones.append(Milestone(title: "Review: \(title)", dueDate: reviewDate))
        }
        
        return milestones
    }
}
