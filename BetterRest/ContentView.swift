import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", 
                value: $sleepAmount,
                in: 4...12, 
                step: 0.25
        )
        DatePicker("When did you wake up ?",
                   selection: $wakeUp,
                   in: getDateRange(from: Date.now, to: .infinity),
                   displayedComponents: .date
        )
        .labelsHidden()
    }
    
    func getDateRange(from date: Date, to futureInSeconds: Double) -> ClosedRange<Date> {
        let tomorrow = date.addingTimeInterval(futureInSeconds)
        return date...tomorrow
    }
}

#Preview {
    ContentView()
}
