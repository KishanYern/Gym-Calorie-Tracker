import Foundation
import SwiftData

@Model
final class ExerciseSet {
    var id: UUID
    var reps: Int
    var weight: Double
    var exercise: Exercise?

    init(reps: Int, weight: Double) {
        self.id = UUID()
        self.reps = reps
        self.weight = weight
    }
}

@Model
final class Exercise {
    var id: UUID
    var activityNomenclature: String
    var chronologicalDuration: TimeInterval
    var date: Date
    var dailySummary: DailySummary?
    @Relationship(deleteRule: .cascade, inverse: \ExerciseSet.exercise) var sets: [ExerciseSet]

    init(activityNomenclature: String, chronologicalDuration: TimeInterval, date: Date = Date(), sets: [ExerciseSet] = []) {
        self.id = UUID()
        self.activityNomenclature = activityNomenclature
        self.chronologicalDuration = chronologicalDuration
        self.date = date
        self.sets = sets
    }
}
