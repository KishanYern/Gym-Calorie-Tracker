import SwiftUI
import SwiftData

@main
struct GymCalorieTrackerApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                Exercise.self,
                Nutrition.self,
                DailySummary.self,
                CatalogItem.self
            ])
            
            // Configuring ModelConfiguration for local SQLite database
            // Note: Offline architecture constraint is met by *not* defining any CloudKit container ID.
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false // False to persist in the app's local sandbox
            )
            
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Execution Step 5: Execute a validation routine
            print("Successfully initialized local SQLite ModelContainer at path: \(modelConfiguration.url.path)")
            
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
