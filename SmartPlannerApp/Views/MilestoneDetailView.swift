//
//  MilestoneDetailView.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import SwiftUI
import MessageUI

// 1. Create a router to safely handle multiple popups
enum ActiveSheet: Identifiable {
    case timer
    case snitch
    
    var id: Int { hashValue }
}

struct MilestoneDetailView: View {
    @ObservedObject var viewModel: AssignmentViewModel
    var assignment: Assignment
    
    // 2. Replace the two booleans with our single active sheet state
    @State private var activeSheet: ActiveSheet? = nil
    @State private var selectedMilestoneName = ""
    @State private var showTextError = false // For unsupported devices
    
    var body: some View {
        List {
            Section(header: Text("Generated Tasks")) {
                ForEach(assignment.milestones) { milestone in
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // Checkbox Row
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
                        
                        // Action Buttons
                        if !milestone.isCompleted {
                            HStack {
                                // Timer Button
                                Button {
                                    selectedMilestoneName = milestone.title
                                    activeSheet = .timer
                                } label: {
                                    Label("Focus", systemImage: "timer")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)
                                
                                Spacer()
                                
                                // Snitch Button
                                if !assignment.snitchPhoneNumber.isEmpty {
                                    Button {
                                        selectedMilestoneName = milestone.title
                                        // 3. The Heavy check is now safely inside the button action!
                                        if MFMessageComposeViewController.canSendText() {
                                            activeSheet = .snitch
                                        } else {
                                            showTextError = true
                                        }
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
        
        // 4. A single, clean sheet modifier routes both views
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .timer:
                PomodoroTimerView(milestoneTitle: selectedMilestoneName)
            case .snitch:
                MessageComposeView(
                    recipients: [assignment.snitchPhoneNumber],
                    body: "I am procrastinating on my \(selectedMilestoneName) and need you to yell at me to get back to work."
                )
            }
        }
        
        // Failsafe for the Simulator
        .alert("Texting Not Supported", isPresented: $showTextError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You need to run this on a physical iPhone to send texts.")
        }
    }
}

#Preview {
    let fakeMilestones = [
        Milestone(title: "Outline", dueDate: Date(), isCompleted: true),
        Milestone(title: "Draft", dueDate: Date(), isCompleted: false)
    ]
    let fakeAssignment = Assignment(
        title: "Test History Essay",
        finalDueDate: Date(),
        milestones: fakeMilestones,
        snitchPhoneNumber: "555-555-5555"
    )
    return NavigationStack {
        MilestoneDetailView(viewModel: AssignmentViewModel(), assignment: fakeAssignment)
    }
}
