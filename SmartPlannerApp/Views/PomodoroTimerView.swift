//
//  PomodoroTimerView.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import SwiftUI
internal import Combine

struct PomodoroTimerView: View {
    var milestoneTitle: String
    
    // 25 minutes calculated in seconds
    @State private var timeRemaining = 25 * 60
    @State private var isRunning = false
    
    // The engine that ticks once every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Currently Focusing On:")
                .font(.title3)
                .foregroundColor(.gray)
            
            Text(milestoneTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Math to format total seconds into MM:SS
            Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                .font(.system(size: 80, weight: .black, design: .monospaced))
                .foregroundColor(isRunning ? .green : .primary)
            
            Button(action: {
                isRunning.toggle()
            }) {
                Text(isRunning ? "Pause" : "Start Focus")
                    .font(.title2)
                    .bold()
                    .frame(width: 200, height: 60)
                    .background(isRunning ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding()
        // Every time the timer "ticks", subtract one second
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                isRunning = false // Timer finished!
            }
        }
    }
}


// This allows the Canvas to show a preview
#Preview {
    PomodoroTimerView(milestoneTitle: "Draft: History Essay")
}


