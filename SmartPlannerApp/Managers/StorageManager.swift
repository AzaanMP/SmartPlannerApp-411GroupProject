//
//  StorageManager.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation

class StorageManager {
    // A "Singleton" ensures only one database manager is writing to the phone at a time.
    static let shared = StorageManager()
    
    // The secret key the iPhone uses to find your specific data file
    private let saveKey = "smartPlannerAssignments"
    
    func save(_ assignments: [Assignment]) {
        if let encoded = try? JSONEncoder().encode(assignments) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func load() -> [Assignment] {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Assignment].self, from: data) {
            return decoded
        }
        return [] // Returns an empty array the very first time the user opens the app
    }
}
