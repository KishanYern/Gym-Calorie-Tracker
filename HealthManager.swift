import Foundation
import HealthKit
import Combine

@MainActor
class HealthManager: ObservableObject {
    static let shared = HealthManager()
    let healthStore = HKHealthStore()
    
    @Published var stepCount: Double = 0.0
    @Published var activeEnergyBurned: Double = 0.0
    @Published var basalEnergyBurned: Double = 0.0
    
    private init() { }
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "HealthManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data not available"])
        }
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let basalType = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let typesToRead: Set<HKObjectType> = [stepType, energyType, basalType]
        
        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
    }
    
    func fetchStepCountForPast7Days() async throws {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: .startOfDay(for: now))!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            query.initialResultsHandler = { [weak self] _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = results else {
                    continuation.resume(return: ())
                    return
                }
                
                var totalSteps = 0.0
                results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        totalSteps += sum.doubleValue(for: HKUnit.count())
                    }
                }
                
                Task { @MainActor in
                    self?.stepCount = totalSteps
                }
                continuation.resume(return: ())
            }
            self.healthStore.execute(query)
        }
    }
    
    func fetchActiveEnergyForPast7Days() async throws {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: .startOfDay(for: now))!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: energyType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            query.initialResultsHandler = { [weak self] _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = results else {
                    continuation.resume(return: ())
                    return
                }
                
                var totalEnergy = 0.0
                results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        totalEnergy += sum.doubleValue(for: HKUnit.kilocalorie())
                    }
                }
                
                Task { @MainActor in
                    self?.activeEnergyBurned = totalEnergy
                }
                continuation.resume(return: ())
            }
            self.healthStore.execute(query)
        }
    }
    
    func fetchBasalEnergyForPast7Days() async throws {
        let basalType = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: .startOfDay(for: now))!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: basalType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            query.initialResultsHandler = { [weak self] _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = results else {
                    continuation.resume(return: ())
                    return
                }
                
                var totalBasal = 0.0
                results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        totalBasal += sum.doubleValue(for: HKUnit.kilocalorie())
                    }
                }
                
                Task { @MainActor in
                    self?.basalEnergyBurned = totalBasal
                }
                continuation.resume(return: ())
            }
            self.healthStore.execute(query)
        }
    }
}
