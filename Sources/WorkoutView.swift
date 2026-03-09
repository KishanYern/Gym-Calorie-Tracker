import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var catalogItems: [CatalogItem]
    
    @State private var selectedDate: Date = Date()
    @State private var exerciseName = ""
    @State private var exerciseDuration = ""
    
    private let commonExercises = ["Squat", "Bench Press", "Deadlift", "Overhead Press", "Pull-up", "Row"]

    @Query(sort: \Exercise.date, order: .reverse) private var exercises: [Exercise]
    
    private var filteredExercises: [Exercise] {
        let calendar = Calendar.current
        return exercises.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                .listRowBackground(Color.surface)

                Section(header: Text("Log Exercise").font(.headline)) {
                    Picker("Exercise Suggestions", selection: $exerciseName) {
                        Text("Custom").tag("")
                        // Default common exercises
                        ForEach(commonExercises, id: \.self) { exercise in
                            Text(exercise).tag(exercise)
                        }
                        // Custom catalog items (ensure we don't duplicate common ones)
                        ForEach(catalogItems.filter { !commonExercises.contains($0.activityNomenclature) }) { item in
                            Text(item.activityNomenclature).tag(item.activityNomenclature)
                        }
                    }
                    TextField("Exercise Name (Custom)", text: $exerciseName)
                        .font(.body)
                    TextField("Duration (seconds)", text: $exerciseDuration)
                        .keyboardType(.decimalPad)
                        .font(.body)
                        .modifier(ThemeTextField())
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                    Button("Add Exercise") {
                        addExercise()
                    }
                    .buttonStyle(GlowButtonStyle())
                    .listRowBackground(Color.clear)
                }
                .listRowBackground(Color.surface)
                
                Section(header: Text("Exercises").font(.headline)) {
                    if filteredExercises.isEmpty {
                        Text("No exercises logged for this date.")
                            .foregroundColor(.secondary)
                    } else {
                        List {
                            ForEach(filteredExercises) { exercise in
                                DisclosureGroup {
                                    ForEach(exercise.sets) { set in
                                        HStack {
                                            Text("\(set.reps) reps @ \(Int(set.weight)) lbs")
                                            Spacer()
                                            Button(role: .destructive) {
                                                deleteSet(set: set, from: exercise)
                                            } label: {
                                                Image(systemName: "trash")
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                    }
                                    
                                    AddSetView(exercise: exercise)
                                } label: {
                                    HStack {
                                        Text(exercise.activityNomenclature).font(.headline)
                                        Spacer()
                                        NavigationLink("", destination: EditExerciseView(exercise: exercise))
                                            .frame(width: 0, height: 0)
                                            .opacity(0)
                                    }
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deleteExercise(exercise)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Color.surface)
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundBase)
            .navigationTitle("Workout")
            .preferredColorScheme(.dark)
        }
        .accentColor(.accentTheme)
    }
    
    private func getSummary(for date: Date) -> DailySummary {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        var summary: DailySummary?
        do {
            let descriptor = FetchDescriptor<DailySummary>()
            let allSummaries = try modelContext.fetch(descriptor)
            summary = allSummaries.first(where: { $0.calendarDateString == dateString })
        } catch {
            print("Failed to fetch daily summaries")
        }
        
        if let existing = summary {
            return existing
        } else {
            let newSummary = DailySummary(date: date)
            modelContext.insert(newSummary)
            return newSummary
        }
    }
    
    private func addExercise() {
        guard !exerciseName.isEmpty,
              let duration = TimeInterval(exerciseDuration) else {
            return
        }
        
        let summary = getSummary(for: selectedDate)
        let newExercise = Exercise(activityNomenclature: exerciseName, chronologicalDuration: duration, date: selectedDate)
        newExercise.dailySummary = summary
        
        modelContext.insert(newExercise)
        
        // Custom Catalog Learning Mechanism
        let isCommon = commonExercises.contains(exerciseName)
        let inCatalog = catalogItems.contains(where: { $0.activityNomenclature == exerciseName })
        if !isCommon && !inCatalog {
            let newItem = CatalogItem(activityNomenclature: exerciseName)
            modelContext.insert(newItem)
        }
        
        exerciseName = ""
        exerciseDuration = ""
    }
    
    private func deleteExercise(_ exercise: Exercise) {
        modelContext.delete(exercise)
    }
    
    private func deleteSet(set: ExerciseSet, from exercise: Exercise) {
        if let index = exercise.sets.firstIndex(where: { $0.id == set.id }) {
            exercise.sets.remove(at: index)
        }
        modelContext.delete(set)
    }
}

struct AddSetView: View {
    @Bindable var exercise: Exercise
    @Environment(\.modelContext) private var modelContext
    
    @State private var reps: String = ""
    @State private var weight: String = ""
    
    var body: some View {
        HStack {
            TextField("Reps", text: $reps)
                .keyboardType(.numberPad)
            TextField("Weight", text: $weight)
                .keyboardType(.decimalPad)
            Button {
                addSet()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.accentTheme)
            }
            .buttonStyle(.borderless)
            .disabled(reps.isEmpty || weight.isEmpty)
        }
        .padding(.vertical, 4)
    }
    
    private func addSet() {
        guard let r = Int(reps), let w = Double(weight) else { return }
        let newSet = ExerciseSet(reps: r, weight: w)
        exercise.sets.append(newSet)
        
        reps = ""
        weight = ""
    }
}

#Preview {
    WorkoutView()
}
