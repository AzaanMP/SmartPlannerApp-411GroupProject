//
//  CalendarView.swift
//  SmartPlannerApp
//
//  Created by Avery Miclea on 4/23/26.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: AssignmentViewModel
    
    // Tracks which month the user is viewing
    @State private var currentMonth: Date = Date()
    // Tracks which date the user tapped
    @State private var selectedDate: Date? = nil
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Month navigation header
                HStack {
                    Button {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .padding()
                    }
                }
                
                // Weekday labels
                LazyVGrid(columns: columns) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Day grid
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(daysInMonth(), id: \.self) { date in
                        if let date = date {
                            let hasTasks = milestonesFor(date: date).count > 0
                            let isSelected = selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!)
                            let isToday = calendar.isDateInToday(date)
                            
                            VStack(spacing: 4) {
                                Text("\(calendar.component(.day, from: date))")
                                    .font(.system(size: 16, weight: isToday ? .bold : .regular))
                                    .foregroundColor(isSelected ? .white : isToday ? .blue : .primary)
                                    .frame(width: 36, height: 36)
                                    .background(isSelected ? Color.blue : Color.clear)
                                    .clipShape(Circle())
                                
                                // Dot indicator for tasks
                                Circle()
                                    .fill(hasTasks ? Color.red : Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                            .onTapGesture {
                                selectedDate = date
                            }
                        } else {
                            // Empty cell for padding at start of month
                            VStack(spacing: 4) {
                                Text("")
                                    .frame(width: 36, height: 36)
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.top, 8)
                
                // Tasks for selected date
                if let selectedDate = selectedDate {
                    let tasks = milestonesFor(date: selectedDate)
                    
                    if tasks.isEmpty {
                        VStack {
                            Spacer()
                            Text("No tasks due on this day!")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        List(tasks, id: \.0.id) { milestone, assignmentTitle in
                            VStack(alignment: .leading) {
                                Text(milestone.title)
                                    .font(.headline)
                                Text("For: \(assignmentTitle)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(milestone.isCompleted ? "✅ Completed" : "⏳ Pending")
                                    .font(.caption)
                                    .foregroundColor(milestone.isCompleted ? .green : .orange)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Tap a date to see tasks due!")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }
    
    // Returns all the days in the current month with padding at the start
    func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        var current = monthInterval.start
        while current < monthInterval.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        
        return days
    }
    
    // Returns all milestones due on a specific date across all assignments
    func milestonesFor(date: Date) -> [(Milestone, String)] {
        var results: [(Milestone, String)] = []
        for assignment in viewModel.assignments {
            for milestone in assignment.milestones {
                if calendar.isDate(milestone.dueDate, inSameDayAs: date) {
                    results.append((milestone, assignment.title))
                }
            }
        }
        return results
    }
}

#Preview {
    CalendarView(viewModel: AssignmentViewModel())
}
