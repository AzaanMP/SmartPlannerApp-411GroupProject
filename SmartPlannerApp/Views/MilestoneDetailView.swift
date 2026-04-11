//
//  MilestoneDetailView.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import SwiftUI
import MessageUI


struct MilestoneDetailView: View {
    @ObservedObject var viewModel: AssignmentViewModel
    var assignment: Assignment
    
    @State private var showingTimer = false
    @State private var showingSnitch = false
    @State private var selectedMilestoneName = ""
    
    var body: some View {
        List {
            Section(header: Text("Generated Tasks")) {
                ForEach(assignment.milestones) { milestone in
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // 1. The Checkbox Row
                        HStack {
                            Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(milestone.isCompleted ? .green : .gray)
                                .font(.title2)
                                .onTapGesture {
                                    viewModel.toggleMilestone(assignmentId: assignment.id, milestoneId: milestone.id)
                                }
                            
                            VStack(alignment: .leading) {
                                Text(milestone.title).strikethrough(milestone.isCompleted)
                                Text(milestone.dueDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption).foregroundColor(.gray)
                            }
                        }
                        
                        // 2. The Phase 4 Action Buttons (Only show if task isn't done!)
                        if !milestone.isCompleted {
                            HStack {
                                // Timer Button
                                Button {
                                    selectedMilestoneName = milestone.title
                                    showingTimer = true
                                } label: {
                                    Label("Focus", systemImage: "timer")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)
                                
                                Spacer()
                                
                                // Snitch Button (Only show if they typed a number in the form)
                                if !assignment.snitchPhoneNumber.isEmpty {
                                    Button {
                                        selectedMilestoneName = milestone.title
                                        showingSnitch = true
                                    } label: {
                                        Label("Confess", systemImage: "message.fill")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.red)
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle(assignment.title)
        
        // Present the Timer Popup
        .sheet(isPresented: $showingTimer) {
            PomodoroTimerView(milestoneTitle: selectedMilestoneName)
        }
        
        // Present the Texting Popup
        .sheet(isPresented: $showingSnitch) {
            if MFMessageComposeViewController.canSendText() {
                MessageComposeView(
                    recipients: [assignment.snitchPhoneNumber],
                    body: "I am procrastinating on my \(selectedMilestoneName) and need you to yell at me to get back to work."
                )
            } else {
                Text("Texting is not supported on this device. You need to plug in a real iPhone to test this!")
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    // 1. Create some fake tasks just for the visual preview
    let fakeMilestones = [
        Milestone(title: "Outline", dueDate: Date(), isCompleted: true),
        Milestone(title: "Draft", dueDate: Date(), isCompleted: false)
    ]
    
    // 2. Package them into a fake assignment
    let fakeAssignment = Assignment(
        title: "Test History Essay",
        finalDueDate: Date(),
        milestones: fakeMilestones,
        snitchPhoneNumber: "555-555-5555"
    )
    
    // 3. Hand the fake data to the view so the Canvas can draw it
    // We wrap it in a NavigationStack so the top title bar shows up correctly!
    return NavigationStack {
        MilestoneDetailView(viewModel: AssignmentViewModel(), assignment: fakeAssignment)
    }
}


