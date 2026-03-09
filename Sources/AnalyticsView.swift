import SwiftUI
import Charts
import SwiftData

struct AnalyticsView: View {
    @Query(sort: \DailySummary.calendarDateString) private var dailySummaries: [DailySummary]
    @Query(sort: \Nutrition.chronologicalTimestamp) private var nutritionLogs: [Nutrition]
    @Query(sort: \Exercise.date) private var exercises: [Exercise]
    
    @StateObject private var healthManager = HealthManager.shared
    
    @AppStorage("fallbackActiveEnergy") private var fallbackActiveEnergy: Double = 0.0
    @AppStorage("fallbackBasalEnergy") private var fallbackBasalEnergy: Double = 0.0
    
    private var totalEnergyExpenditure: Double {
        let active = healthManager.activeEnergyBurned > 0 ? healthManager.activeEnergyBurned : fallbackActiveEnergy
        let basal = healthManager.basalEnergyBurned > 0 ? healthManager.basalEnergyBurned : fallbackBasalEnergy
        return active + basal
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Caloric Intake vs Expenditure")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .accessibilityAddTraits(.isHeader)
                    
                    Chart {
                        if dailySummaries.isEmpty {
                            BarMark(x: .value("Day", "Mon"), y: .value("Calories", 2500))
                                .foregroundStyle(Color.blue)
                            BarMark(x: .value("Day", "Tue"), y: .value("Calories", 2400))
                                .foregroundStyle(Color.blue)
                            BarMark(x: .value("Day", "Wed"), y: .value("Calories", 2600))
                                .foregroundStyle(Color.blue)
                        } else {
                            ForEach(dailySummaries) { summary in
                                let totalIntake = summary.nutritionLogs.reduce(0) { $0 + $1.caloricValue }
                                BarMark(
                                    x: .value("Date", summary.calendarDateString),
                                    y: .value("Caloric Intake", totalIntake)
                                )
                                .foregroundStyle(Color.blue.gradient)
                            }
                        }
                        
                        RuleMark(y: .value("Total Energy", totalEnergyExpenditure))
                            .foregroundStyle(Color.red)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                            .annotation(position: .top, alignment: .leading) {
                                Text("Total Energy Exp.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [2]))
                                .foregroundStyle(Color.borderDefault)
                            AxisTick()
                                .foregroundStyle(Color.borderDefault)
                            AxisValueLabel()
                                .foregroundStyle(Color.foregroundMuted)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom) { value in
                            AxisValueLabel()
                                .foregroundStyle(Color.foregroundMuted)
                        }
                    }
                    .frame(height: 250)
                    .modifier(GlassCard())
                    .padding(.horizontal)
                    .accessibilityLabel("Caloric Intake Bar Chart against Energy Expenditure")

                    Text("Exercise Volume (Sets x Reps)")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .accessibilityAddTraits(.isHeader)
                    
                    Chart {
                        if exercises.isEmpty {
                            LineMark(x: .value("Day", "Mon"), y: .value("Volume", 150))
                            LineMark(x: .value("Day", "Tue"), y: .value("Volume", 180))
                            LineMark(x: .value("Day", "Wed"), y: .value("Volume", 130))
                        } else {
                            ForEach(exercises) { exercise in
                                LineMark(
                                    x: .value("Date", exercise.date, unit: .day),
                                    y: .value("Volume", exercise.sets.reduce(0) { $0 + ($1.reps * Int($1.weight)) })
                                )
                                .symbol(Circle())
                                .foregroundStyle(Color.green)
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [2]))
                                .foregroundStyle(Color.borderDefault)
                            AxisTick()
                                .foregroundStyle(Color.borderDefault)
                            AxisValueLabel()
                                .foregroundStyle(Color.foregroundMuted)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom) { value in
                            AxisValueLabel()
                                .foregroundStyle(Color.foregroundMuted)
                        }
                    }
                    .frame(height: 250)
                    .modifier(GlassCard())
                    .padding(.horizontal)
                    .accessibilityLabel("Exercise Volume Line Chart")
                }
                .padding(.vertical)
                }
            }
            .background(Color.backgroundBase)
            .navigationTitle("Analytics")
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    do {
                        try await healthManager.requestAuthorization()
                        try await healthManager.fetchActiveEnergyForPast7Days()
                        try await healthManager.fetchBasalEnergyForPast7Days()
                    } catch {
                        print("Error fetching health data: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    AnalyticsView()
}
