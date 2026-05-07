//
//  RedpointApp.swift
//  Redpoint
//
//  Created by Anirudh Lakkaraju on 4/26/26.
//

import SwiftUI

@main
struct RedpointApp: App {
    init() {
        _ = DatabaseManager.shared
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
