//
//  Assignment.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation

struct Assignment: Identifiable, Codable, Equatable {
    var id = UUID()                  // Unique ID for the whole assignment
    var title: String                // Main title (e.g., "History Essay")
    var finalDueDate: Date           // The ultimate deadline for the professor
    
    // This holds an array (list) of the smaller Milestone chunks we defined above
    var milestones: [Milestone]
    
    // Our new feature: The phone number to text if you procrastinate!
    // We give it a default value of "" (an empty string) just in case the user doesn't want to use this feature.
    var snitchPhoneNumber: String = ""
}
