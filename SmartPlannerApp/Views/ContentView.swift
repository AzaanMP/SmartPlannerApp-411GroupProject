//
//  ContentView.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import SwiftUI


struct ContentView: View {
    // We use @StateObject here because this is where the ViewModel is officially born
    @StateObject var viewModel = AssignmentViewModel()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.assignments.isEmpty {
                    Text("No homework yet. Tap + to add some!")
                        .foregroundColor(.gray)
                } else {
                    // Loop through the data and create a row for each assignment
                    ForEach(viewModel.assignments) { assignment in
                        NavigationLink(destination: MilestoneDetailView(viewModel: viewModel, assignment: assignment)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(assignment.title)
                                        .font(.headline)
                                    Spacer()
                                    // Color coded priority badge
                                    Text(assignment.priority.rawValue)
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(assignment.priority == .high ? Color.red :
                                                    assignment.priority == .medium ? Color.orange : Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                Text("Due: \(assignment.finalDueDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            
                            }
                        }
                    }
                    // Swipe to delete feature!
                    .onDelete { indexSet in
                        viewModel.assignments.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Smart Planner")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddAssignmentView(viewModel: viewModel)
            }
            .onAppear {
                // The absolute first time the app opens, ask for notification permissions
                NotificationManager.shared.requestPermission()
            }
        }
    }
}


#Preview {
    ContentView()
}
