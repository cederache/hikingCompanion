//
//  DatabaseManager.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import Foundation
import RealmSwift
import Sentry

class DatabaseManager {
    static let Instance = DatabaseManager()

    var debug: Bool = false
    private var _realm: Realm?
    var realmQueue = DispatchQueue(label: "RealmQueue")

    static func InitForDebug() {
        DatabaseManager.Instance.debug = true
    }

    var realm: Realm {
        if _realm == nil {
            initRealm()
        }
        return _realm!
    }

    private init() {
        initRealm()
    }

    private init(debug: Bool = false) {
        self.debug = debug
        initRealm()
    }

    private func initRealm() {
        let crumb = Breadcrumb()
        crumb.level = SentryLevel.info
        crumb.category = "techHistory"
        crumb.message = "DatabaseManager initRealm"
        SentrySDK.addBreadcrumb(crumb: crumb)

        // Custom Sentry transaction performance monitoring
        let transaction = SentrySDK.startTransaction(
            name: "database-realm-init",
            operation: "database-realm-init"
        )

        do {
            if debug {
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "HikingCompanion"
            } else {
                // Use customConfiguration to handle schema migration : https://stackoverflow.com/a/33363554
                let newSchemaVersion: UInt64 = 1
                let configuration = Realm.Configuration(
                    schemaVersion: newSchemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        let crumb = Breadcrumb()
                        crumb.level = SentryLevel.info
                        crumb.category = "techHistory"
                        crumb.message = "DatabaseManager migrationBlock (from \(oldSchemaVersion) to \(newSchemaVersion))"
                        SentrySDK.addBreadcrumb(crumb: crumb)
                        
                    }
                )
                Realm.Configuration.defaultConfiguration = configuration
            }
            _realm = try Realm()

            let crumb = Breadcrumb()
            crumb.level = SentryLevel.info
            crumb.category = "techHistory"
            crumb.message = "DatabaseManager initRealm successfull"
            SentrySDK.addBreadcrumb(crumb: crumb)
        } catch {
            logger.error("Error while initializing realm \(error)")
            SentrySDK.capture(message: "Error while initializing realm \(error)")
            _realm = nil
        }

        transaction.finish()
    }
}
