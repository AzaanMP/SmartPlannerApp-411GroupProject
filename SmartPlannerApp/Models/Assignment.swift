//
//  Assignment.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation

// Priority levels
enum Priority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

// New! Common college subjects to choose from
enum Subject: String, Codable, CaseIterable {
    case general = "General"
    case math = "Math"
    case english = "English"
    case history = "History"
    case science = "Science"
    case computerScience = "Computer Science"
    case art = "Art"
    case other = "Other"
}

struct Assignment: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var finalDueDate: Date
    var milestones: [Milestone]
    var snitchPhoneNumber: String = ""
    var priority: Priority = .medium
    
    // New! Subject tag, defaults to General
    var subject: Subject = .general
}
