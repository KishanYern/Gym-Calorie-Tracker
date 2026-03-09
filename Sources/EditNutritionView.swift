import SwiftUI
import SwiftData

struct EditNutritionView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var nutrition: Nutrition
    
    @State private var caloricValue: String = ""
    @State private var protein: String = ""
    @State private var carbohydrates: String = ""
    @State private var fat: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Total Calories", text: $caloricValue)
                    .keyboardType(.decimalPad)
                TextField("Protein (g)", text: $protein)
                    .keyboardType(.decimalPad)
                TextField("Carbohydrates (g)", text: $carbohydrates)
                    .keyboardType(.decimalPad)
                TextField("Fat (g)", text: $fat)
                    .keyboardType(.decimalPad)
            }
            .listRowBackground(Color.surface)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundBase)
            .navigationTitle("Edit Nutrition")
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
            }
            .onAppear {
                caloricValue = "\(nutrition.caloricValue)"
                protein = "\(nutrition.protein)"
                carbohydrates = "\(nutrition.carbohydrates)"
                fat = "\(nutrition.fat)"
            }
        }
    }
    
    private func save() {
        if let calories = Double(caloricValue) {
            nutrition.caloricValue = calories
        }
        if let p = Double(protein) {
            nutrition.protein = p
        }
        if let c = Double(carbohydrates) {
            nutrition.carbohydrates = c
        }
        if let f = Double(fat) {
            nutrition.fat = f
        }
    }
}
