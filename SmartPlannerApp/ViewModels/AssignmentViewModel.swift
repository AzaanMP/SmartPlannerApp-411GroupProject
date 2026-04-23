//
//  AssignmentViewModel.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation
internal import Combine

class AssignmentViewModel: ObservableObject {
    
    // @Published is SwiftUI magic. It means "Any time this array changes, instantly redraw the screen!"
    @Published var assignments: [Assignment] = [] {
        didSet {
            // Because of this 'didSet', anytime you add homework or check a box, it automatically saves to the phone. You never have to write a 'save' command again.
            StorageManager.shared.save(assignments)
        }
    }
    
    init() {
        // When the app first opens, load whatever is saved on the hard drive.
        self.assignments = StorageManager.shared.load()
    }
    
    // The master function to create a new assignment
    func addAssignment(title: String, dueDate: Date, snitchNumber: String, priority: Priority = .medium, subject: Subject = .general) {        // 1. Ask the DateHelper to do the math
        let generatedMilestones = DateHelper.generateMilestones(for: title, finalDate: dueDate)
        
        // 2. Package it all together into our Data Model
        let newAssignment = Assignment(
            title: title,
            finalDueDate: dueDate,
            milestones: generatedMilestones,
            snitchPhoneNumber: snitchNumber,
            priority: priority,
            subject: subject
        )
        
        // 3. Add it to the master list
        assignments.append(newAssignment)
        
        // 4. Set the alarms
        for milestone in generatedMilestones {
            NotificationManager.shared.scheduleReminder(for: milestone)
        }
    }
    
    // The master function to check off a task
    func toggleMilestone(assignmentId: UUID, milestoneId: UUID) {
        if let aIndex = assignments.firstIndex(where: { $0.id == assignmentId }),
           let mIndex = assignments[aIndex].milestones.firstIndex(where: { $0.id == milestoneId }) {
            
            // Flip the boolean (if false, make true. If true, make false)
            assignments[aIndex].milestones[mIndex].isCompleted.toggle()
            
            // This little trick forces the @Published property to realize a deep change happened so it redraws the checkboxes
            let updatedAssignments = assignments
            assignments = updatedAssignments
        }
    }
}
