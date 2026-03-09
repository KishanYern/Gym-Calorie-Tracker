import SwiftUI
import SwiftData

struct NutritionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Nutrition.chronologicalTimestamp, order: .reverse) private var allNutrition: [Nutrition]
    
    @State private var selectedDate = Date()
    @State private var mealName = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    
    let dailyProteinGoal: Double = 150.0 // Mock goal
    
    private var selectedDateNutrition: [Nutrition] {
        let calendar = Calendar.current
        return allNutrition.filter { calendar.isDate($0.chronologicalTimestamp, inSameDayAs: selectedDate) }
    }
    
    private var totalProteinForSelectedDate: Double {
        selectedDateNutrition.reduce(0) { $0 + $1.protein }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Date Picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding()
                
                // Protein Tracker
                VStack {
                    Text("Daily Protein Goal")
                        .font(.headline)
                    ProgressView(value: min(totalProteinForSelectedDate, dailyProteinGoal), total: dailyProteinGoal)
                        .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                        .padding(.horizontal)
                    Text("\(Int(totalProteinForSelectedDate))g / \(Int(dailyProteinGoal))g")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
                
                Form {
                    Section(header: Text("Log Meal")) {
                        TextField("Meal Name (e.g., Breakfast)", text: $mealName)
                        TextField("Calories (kcal)", text: $calories)
                            .keyboardType(.decimalPad)
                        TextField("Protein (g)", text: $protein)
                            .keyboardType(.decimalPad)
                        TextField("Carbs (g)", text: $carbs)
                            .keyboardType(.decimalPad)
                        TextField("Fat (g)", text: $fat)
                            .keyboardType(.decimalPad)
                        
                        Button("Add Meal") {
                            logMeal()
                        }
                        .disabled(mealName.isEmpty || calories.isEmpty)
                        .buttonStyle(GlowButtonStyle())
                    }
                    
                    Section(header: Text("Meals for Selected Date")) {
                        if selectedDateNutrition.isEmpty {
                            Text("No meals logged for this date.")
                                .foregroundColor(.secondary)
                        } else {
                            List {
                                ForEach(selectedDateNutrition) { nutrition in
                                    VStack(alignment: .leading) {
                                        Text(nutrition.mealName)
                                            .font(.headline)
                                        HStack {
                                            Text("\(Int(nutrition.caloricValue)) kcal")
                                            Spacer()
                                            Text("P:\(Int(nutrition.protein))g C:\(Int(nutrition.carbohydrates))g F:\(Int(nutrition.fat))g")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .onDelete(perform: deleteNutrition)
                            }
                        }
                    }
                }
            }
            .background(Color.backgroundBase)
            .navigationTitle("Nutrition")
        }
    }
    
    private func getDailySummary(for date: Date) -> DailySummary {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let descriptor = FetchDescriptor<DailySummary>()
        let allSummaries = (try? modelContext.fetch(descriptor)) ?? []
        if let existing = allSummaries.first(where: { $0.calendarDateString == dateString }) {
            return existing
        } else {
            let newSummary = DailySummary(date: date)
            modelContext.insert(newSummary)
            return newSummary
        }
    }
    
    private func logMeal() {
        guard let calValue = Double(calories), !mealName.isEmpty else { return }
        let pValue = Double(protein) ?? 0
        let cValue = Double(carbs) ?? 0
        let fValue = Double(fat) ?? 0
        
        let newNutrition = Nutrition(
            mealName: mealName,
            caloricValue: calValue,
            protein: pValue,
            carbohydrates: cValue,
            fat: fValue,
            chronologicalTimestamp: selectedDate
        )
        
        let summary = getDailySummary(for: selectedDate)
        newNutrition.dailySummary = summary
        
        modelContext.insert(newNutrition)
        
        mealName = ""
        calories = ""
        protein = ""
        carbs = ""
        fat = ""
    }
    
    private func deleteNutrition(at offsets: IndexSet) {
        for index in offsets {
            let nutrition = selectedDateNutrition[index]
            modelContext.delete(nutrition)
        }
    }
}

#Preview {
    NutritionView()
}
