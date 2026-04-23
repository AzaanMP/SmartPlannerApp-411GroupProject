//
//  AddAssignmentView.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import SwiftUI

struct AddAssignmentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AssignmentViewModel
    
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var snitchNumber: String = ""
    @State private var priority: Priority = .medium
    @State private var subject: Subject = .general
    
    // New! Holds the list of milestones the user can edit
    @State private var customMilestones: [Milestone] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Assignment Details")) {
                    TextField("Title (e.g. History Essay)", text: $title)
                    DatePicker("Final Deadline", selection: $dueDate, displayedComponents: .date)
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    Picker("Subject", selection: $subject) {
                        ForEach(Subject.allCases, id: \.self) { sub in
                            Text(sub.rawValue).tag(sub)
                        }
                    }
                }
                
                // New! Custom milestones section
                Section(header: Text("Milestones"), footer: Text("These are auto-generated but you can add, edit or delete them.")) {
                    ForEach($customMilestones) { $milestone in
                        VStack(alignment: .leading) {
                            TextField("Task name", text: $milestone.title)
                                .font(.headline)
                            DatePicker("Due", selection: $milestone.dueDate, displayedComponents: .date)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        customMilestones.remove(atOffsets: indexSet)
                    }
                    
                    // Add new milestone button
                    Button {
                        let newMilestone = Milestone(title: "", dueDate: dueDate)
                        customMilestones.append(newMilestone)
                    } label: {
                        Label("Add Task", systemImage: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("Accountability"), footer: Text("Optional: Enter a friend's phone number. If you slack off, the app will text them to yell at you.")) {
                    TextField("Snitch Phone Number", text: $snitchNumber)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("New Homework")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addAssignment(
                            title: title,
                            dueDate: dueDate,
                            snitchNumber: snitchNumber,
                            priority: priority,
                            subject: subject,
                            customMilestones: customMilestones.isEmpty ? nil : customMilestones
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            // New! When the title or due date changes, auto-generate milestones
            .onChange(of: dueDate) { _ in
                if customMilestones.isEmpty {
                    customMilestones = DateHelper.generateMilestones(for: title, finalDate: dueDate)
                }
            }
            .onChange(of: title) { _ in
                if !title.isEmpty {
                    customMilestones = DateHelper.generateMilestones(for: title, finalDate: dueDate)
                }
            }
        }
    }
}

#Preview {
    AddAssignmentView(viewModel: AssignmentViewModel())
}
