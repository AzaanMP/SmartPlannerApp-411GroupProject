//
//  ContentView.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = AssignmentViewModel()
    @State private var showingAddSheet = false
    @State private var selectedSubject: Subject? = nil
    
    // New! Tracks the current color scheme preference
    @State private var colorScheme: ColorScheme? = nil

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button {
                        selectedSubject = nil
                    } label: {
                        Text("All")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedSubject == nil ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedSubject == nil ? .white : .primary)
                            .cornerRadius(20)
                    }
                    ForEach(Subject.allCases, id: \.self) { subject in
                        Button {
                            selectedSubject = subject
                        } label: {
                            Text(subject.rawValue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedSubject == subject ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedSubject == subject ? .white : .primary)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            List {
                if viewModel.assignments.isEmpty {
                    Text("No homework yet. Tap + to add some!")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.assignments.filter { selectedSubject == nil || $0.subject == selectedSubject }) { assignment in
                        NavigationLink(destination: MilestoneDetailView(viewModel: viewModel, assignment: assignment)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(assignment.title)
                                        .font(.headline)
                                    Spacer()
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
                                Text(assignment.subject.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.blue)

                                let completed = assignment.milestones.filter { $0.isCompleted }.count
                                let total = assignment.milestones.count

                                if total > 0 {
                                    VStack(alignment: .leading, spacing: 2) {
                                        ProgressView(value: Double(completed), total: Double(total))
                                            .tint(completed == total ? .green : .blue)
                                        Text("\(completed)/\(total) tasks done")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.top, 4)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.assignments.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Smart Planner")
            .toolbar {
                // New! Dark/Light mode toggle on the left
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        switch colorScheme {
                        case .none:
                            colorScheme = .light
                        case .light:
                            colorScheme = .dark
                        case .dark:
                            colorScheme = .none
                        default:
                            colorScheme = .none
                        }
                    } label: {
                        Image(systemName: colorScheme == .dark ? "moon.fill" :
                                          colorScheme == .light ? "sun.max.fill" : "circle.lefthalf.filled")
                    }
                }
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
                NotificationManager.shared.requestPermission()
            }
        }
        // New! Applies the color scheme to the entire app
        .preferredColorScheme(colorScheme)
    }
}

#Preview {
    ContentView()
}
