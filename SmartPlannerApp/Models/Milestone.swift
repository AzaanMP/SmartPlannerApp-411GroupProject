//
//  Milestone.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation

// We make it 'Identifiable' so SwiftUI lists can tell each row apart.
// We make it 'Codable' so it can be converted to JSON and saved to the phone.
// We make it 'Equatable' so SwiftUI knows when to redraw the screen if a checkbox changes.
struct Milestone: Identifiable, Codable, Equatable {
    var id = UUID()              // Generates a unique, invisible background ID
    var title: String            // The name of the task (e.g., "First Draft")
    var dueDate: Date            // The exact date and time this specific piece is due
    var isCompleted: Bool = false // Starts unchecked by default
}
