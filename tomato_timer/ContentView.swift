//
//  ContentView.swift
//  tomato_timer
//
//  Created by Mingcan Li on 2/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining: Int = 60 // Default countdown time
    @State private var timer: Timer?
    @State private var timerRunning = false
    @State private var selectedMinutes = 1 // Default 1 min
    @State private var selectedSeconds = 0 // Default 0 sec
    @State private var countdownStarted = false // Track if countdown has started

    var body: some View {
        ZStack {
            // Light cream/yellow background for a warm feel
            Color(red: 1.0, green: 0.98, blue: 0.88).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Countdown Timer
                Text(formatTime(timeRemaining))
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .foregroundColor(getCountdownColor()) // Dynamic color change
                    .frame(maxWidth: .infinity, maxHeight: 180, alignment: .center)

                // Show Pickers & Quick Buttons only before countdown starts
                if !countdownStarted {
                    VStack(spacing: 20) {
                        Text("Select countdown time")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.gray)

                        // Quick Selection Buttons
                        HStack(spacing: 15) {
                            QuickSelectButton(label: "5 min", time: 5 * 60, action: updateTimerFromQuickSelect)
                            QuickSelectButton(label: "20 min", time: 20 * 60, action: updateTimerFromQuickSelect)
                            QuickSelectButton(label: "30 min", time: 30 * 60, action: updateTimerFromQuickSelect)
                        }

                        // Two Pickers for Minutes and Seconds
                        HStack {
                            // Minute Picker
                            Picker("Minutes", selection: $selectedMinutes) {
                                ForEach(0...59, id: \.self) { minute in
                                    Text("\(minute) min").foregroundColor(.black)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 120, height: 150)
                            .clipped()

                            // Second Picker
                            Picker("Seconds", selection: $selectedSeconds) {
                                ForEach(0...59, id: \.self) { second in
                                    Text("\(second) sec").foregroundColor(.black)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 120, height: 150)
                            .clipped()
                        }
                        .background(Color.white.opacity(0.8)) // Subtle white background
                        .cornerRadius(15)
                        .onChange(of: selectedMinutes) { _ in updateTimer() }
                        .onChange(of: selectedSeconds) { _ in updateTimer() }
                    }
                }

                // Buttons
                HStack(spacing: 25) {
                    if !countdownStarted {
                        // Show only Start button before countdown begins
                        Button("Start") { startTimer() }
                            .buttonStyle(CustomButtonStyle(backgroundColor: .blue))
                    } else {
                        // Show Pause & Reset buttons during countdown
                        Button("Pause") { stopTimer() }
                            .buttonStyle(CustomButtonStyle(backgroundColor: .yellow))

                        Button("Reset") { resetTimer() }
                            .buttonStyle(CustomButtonStyle(backgroundColor: .red))
                    }
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
    }

    // Converts seconds to MM:SS format
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Determines countdown color
    func getCountdownColor() -> Color {
        return timeRemaining < 60 ? Color.red : Color.green
    }

    // Starts the countdown timer
    func startTimer() {
        timeRemaining = selectedMinutes * 60 + selectedSeconds
        countdownStarted = true
        timerRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timerRunning = false
                countdownStarted = false
            }
        }
    }

    // Stops the timer
    func stopTimer() {
        timer?.invalidate()
        timerRunning = false
    }

    // Resets the timer
    func resetTimer() {
        stopTimer()
        updateTimer()
        countdownStarted = false
    }

    // Updates the timer value based on selected minutes & seconds
    func updateTimer() {
        timeRemaining = selectedMinutes * 60 + selectedSeconds
    }

    // Updates timer from quick select buttons
    func updateTimerFromQuickSelect(_ seconds: Int) {
        selectedMinutes = seconds / 60
        selectedSeconds = seconds % 60
        updateTimer()
    }
}

// Custom Button Style with Rounded Corners
struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 22, weight: .bold))
            .frame(width: 110, height: 55)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(15)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// Quick Select Button Component
struct QuickSelectButton: View {
struct QuickSelectButton: View {
    let label: String
    let time: Int
    let action: (Int) -> Void

    var body: some View {
        Button(action: { action(time) }) {
            Text(label)
                .font(.system(size: 18, weight: .bold))
                .frame(width: 90, height: 45)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
}
