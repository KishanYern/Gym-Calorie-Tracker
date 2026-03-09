import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "figure.run.circle.fill")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife.circle.fill")
                }
            
            IntegrationView()
                .tabItem {
                    Label("Integration", systemImage: "heart.text.square.fill")
                }
        }
        .preferredColorScheme(.dark)
        .accentColor(.accentTheme)
    }
}

#Preview {
    MainTabView()
}
