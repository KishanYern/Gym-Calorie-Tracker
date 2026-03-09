import SwiftUI
import SwiftData

struct EditExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var exercise: Exercise
    
    // Using intermediate state variables to bind to text fields
    // since TextFields require String bindings.
    @State private var activityNomenclature: String = ""
    @State private var chronologicalDuration: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Exercise Name", text: $activityNomenclature)
                TextField("Duration (seconds)", text: $chronologicalDuration)
                    .keyboardType(.decimalPad)
            }
            .listRowBackground(Color.surface)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundBase)
            .navigationTitle("Edit Exercise")
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
                activityNomenclature = exercise.activityNomenclature
                chronologicalDuration = "\(Int(exercise.chronologicalDuration))"
            }
        }
    }
    
    private func save() {
        exercise.activityNomenclature = activityNomenclature
        if let duration = TimeInterval(chronologicalDuration) {
            exercise.chronologicalDuration = duration
        }
    }
}
