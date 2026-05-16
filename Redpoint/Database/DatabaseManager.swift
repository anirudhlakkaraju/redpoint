//
//  DatabaseManager.swift
//  Redpoint
//
//  Created by Anirudh Lakkaraju on 5/3/26.
//
import Foundation
import GRDB

final class DatabaseManager {
    static let shared = DatabaseManager()
    let dbPool: DatabasePool
    
    private init() {
        do {
            let dbURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask,
                     appropriateFor: nil, create: true)
                .appendingPathComponent("redpoint.sqlite")
            dbPool = try DatabasePool(path: dbURL.path)
            try Migrations.run(on: dbPool)
        } catch {
            fatalError("Database setup failed: \(error)")
        }
    }
}
