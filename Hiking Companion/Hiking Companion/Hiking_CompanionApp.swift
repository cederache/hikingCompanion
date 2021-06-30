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
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    SentrySDK.start { options in
                        options.dsn = "https://eb6baf06b0be4da1b7423897940e7c4b@o896699.ingest.sentry.io/5841313"
                        options.debug = false
                        
                        options.environment = "development"
                        
                        // Issues
                        options.enableAutoSessionTracking = true
                        options.enableOutOfMemoryTracking = true
                        
                        // Performance
                        options.tracesSampleRate = 0.25
                    }
                }
        }
    }
}
