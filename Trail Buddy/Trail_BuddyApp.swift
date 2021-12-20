//
//  Hiking_CompanionApp.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import Sentry
import SwiftUI

@main
struct Hiking_CompanionApp: App {
    func onAppear() {
        SentrySDK.start { options in
            options.dsn = "https://015be32dc7d9457a8776f9d933961d04@o1095317.ingest.sentry.io/6114659"
            options.debug = true
            
            options.environment = "development"
            
            // Issues
            options.enableAutoSessionTracking = true
            options.enableOutOfMemoryTracking = true
            
            // Performance
            options.tracesSampleRate = 0.25
        }
        
        // Init Database (Realm)
        _ = DatabaseManager.Instance
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(perform: onAppear)
                .environmentObject(ListItemsStore.Instance)
        }
    }
}
