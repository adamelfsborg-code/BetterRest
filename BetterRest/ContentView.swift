import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up ?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep ?") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Coffee cups per day ?") {
                    Picker("Daily coffee intake", selection: $coffeAmount) {
                        ForEach(1..<21) {
                            Text("^[\($0) cup](inflect:true)")
                        }
                    }
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            
            VStack() {
                Text(alertTitle)
                    .font(.headline)
                Text(alertMessage)
                    .font(.largeTitle.bold())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mint)
            .foregroundColor(.primary)
        }
    }

    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            let hourInSec = (components.hour ?? 0) * 60 * 60
            let minuteInSec = (components.minute ?? 0) * 60
            
            let predition = try model.prediction(wake: Double(hourInSec + minuteInSec), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            
            let bedTime = wakeUp - predition.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = bedTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bed time."
            
        }
    }
}

#Preview {
    ContentView()
}
