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
    @State private var snitchNumber: String = "" // Our new Phase 4 field!
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Assignment Details")) {
                    TextField("Title (e.g. History Essay)", text: $title)
                    DatePicker("Final Deadline", selection: $dueDate, displayedComponents: .date)
                }
                
                Section(header: Text("Accountability"), footer: Text("Optional: Enter a friend's phone number. If you slack off, the app will text them to yell at you.")) {
                    TextField("Snitch Phone Number", text: $snitchNumber)
                        .keyboardType(.phonePad) // Brings up the number pad instead of standard letters
                }
            }
            .navigationTitle("New Homework")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Pass all three pieces of data to your ViewModel
                        viewModel.addAssignment(title: title, dueDate: dueDate, snitchNumber: snitchNumber)
                        dismiss()
                    }
                    .disabled(title.isEmpty) // Prevent them from saving blank homework
                }
            }
        }
    }
}

#Preview {
    AddAssignmentView(viewModel: AssignmentViewModel())
}
