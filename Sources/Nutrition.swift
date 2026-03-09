import Foundation
import SwiftData

@Model
final class Nutrition {
    var id: UUID
    var mealName: String
    var caloricValue: Double
    var protein: Double
    var carbohydrates: Double
    var fat: Double
    var chronologicalTimestamp: Date
    var dailySummary: DailySummary?

    init(mealName: String = "Unknown Meal", caloricValue: Double = 0, protein: Double = 0, carbohydrates: Double = 0, fat: Double = 0, chronologicalTimestamp: Date = Date()) {
        self.id = UUID()
        self.mealName = mealName
        self.caloricValue = caloricValue
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.chronologicalTimestamp = chronologicalTimestamp
    }
}
