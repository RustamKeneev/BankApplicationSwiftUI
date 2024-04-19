//
//  BankApplicationSwiftUIApp.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 20/4/24.
//

import SwiftUI

@main
struct BankApplicationSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
