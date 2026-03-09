import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "figure.run")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Gym Calorie Tracker")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
