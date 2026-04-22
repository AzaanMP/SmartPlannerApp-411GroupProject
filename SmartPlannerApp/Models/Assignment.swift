//
//  Assignment.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation

// New! Defines the 3 priority levels an assignment can have
enum Priority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct Assignment: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var finalDueDate: Date
    var milestones: [Milestone]
    var snitchPhoneNumber: String = ""
    
    // New! Priority level, defaults to medium if not set
    var priority: Priority = .medium
}
