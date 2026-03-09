import Foundation
import SwiftData

@Model
final class DailySummary {
    var id: UUID
    @Attribute(.unique) var calendarDateString: String
    
    @Relationship(deleteRule: .cascade, inverse: \Exercise.dailySummary)
    var exercises: [Exercise] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Nutrition.dailySummary)
    var nutritionLogs: [Nutrition] = []

    init(date: Date = Date()) {
        self.id = UUID()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.calendarDateString = formatter.string(from: date)
    }
}
