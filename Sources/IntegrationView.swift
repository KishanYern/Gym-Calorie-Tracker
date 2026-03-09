import SwiftUI

struct IntegrationView: View {
    @StateObject private var healthManager = HealthManager.shared
    @State private var authError: String? = nil
    
    @AppStorage("fallbackStepCount") private var fallbackStepCount: Double = 0.0
    @AppStorage("fallbackActiveEnergy") private var fallbackActiveEnergy: Double = 0.0
    @AppStorage("fallbackBasalEnergy") private var fallbackBasalEnergy: Double = 0.0
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Health Data (Past 7 Days)").font(.headline)) {
                    HStack {
                        Label("Step Count", systemImage: "figure.walk")
                            .font(.body)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(Int(healthManager.stepCount)) steps")
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                    
                    HStack {
                        Label("Active Energy", systemImage: "flame.fill")
                            .font(.body)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(Int(healthManager.activeEnergyBurned)) kcal")
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                }
                .listRowBackground(Color.surface)
                
                if let error = authError {
                    Section(header: Text("Authorization Error").font(.headline)) {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .listRowBackground(Color.surface)
                    
                    Section(header: Text("Manual Offline Overrides").font(.headline)) {
                        VStack(alignment: .leading) {
                            Text("Step Count (\(Int(fallbackStepCount)))")
                            Stepper("Steps", value: $fallbackStepCount, in: 0...50000, step: 100)
                                .labelsHidden()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Active Energy (\(Int(fallbackActiveEnergy)) kcal)")
                            Stepper("Active Cal", value: $fallbackActiveEnergy, in: 0...10000, step: 50)
                                .labelsHidden()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Basal Energy (\(Int(fallbackBasalEnergy)) kcal)")
                            Stepper("Basal Cal", value: $fallbackBasalEnergy, in: 0...10000, step: 50)
                                .labelsHidden()
                        }
                    }
                }
                .listRowBackground(Color.surface)
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundBase)
            .navigationTitle("Integration")
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    do {
                        try await healthManager.requestAuthorization()
                        try await healthManager.fetchStepCountForPast7Days()
                        try await healthManager.fetchActiveEnergyForPast7Days()
                        try await healthManager.fetchBasalEnergyForPast7Days()
                    } catch {
                        authError = error.localizedDescription
                    }
                }
            }
        }
        .accentColor(.accentTheme)
    }
}

#Preview {
    IntegrationView()
}
