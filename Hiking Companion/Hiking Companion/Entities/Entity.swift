//
//  Entity.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import Foundation
import RealmSwift

// MARK: - Realm

@objc protocol Entity {
    @objc dynamic var id: String { get set }
}

extension Entity {
    var localPrefix: String {
        return "local_"
    }

    var isLocal: Bool {
        return id.starts(with: localPrefix)
    }

    func newId() -> String {
        return localPrefix + randomString(length: 10)
    }

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }

    func checkId() {
        if id.isEmpty {
            id = newId()
        }
    }
}

@objc protocol EntitySafe {
    @objc dynamic var _id: String { get set }

    var id: String { get }
    var isInvalidated: Bool { get }
}

extension EntitySafe {
    var localPrefix: String {
        return "local_"
    }

    var isLocal: Bool {
        return id.starts(with: localPrefix)
    }

    func newId() -> String {
        return localPrefix + randomString(length: 10)
    }

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }

    func checkId() {
        if id.isEmpty && !isInvalidated {
            _id = newId()
        }
    }
}

extension Array where Element: Entity {
    mutating func removeIfExists(item: Entity) {
        if let index = firstIndex(where: { $0.id == item.id }) {
            remove(at: index)
        }
    }
}

extension Array where Element: EntitySafe {
    mutating func removeIfExists(item: EntitySafe) {
        if let index = firstIndex(where: { $0.id == item.id }) {
            remove(at: index)
        }
    }
}

// MARK: - SwiftUI

protocol EntityStruct {
    var id: String { get set }
}

extension EntityStruct {
    static var localPrefix: String {
        "local_"
    }

    var isLocal: Bool {
        return id.starts(with: Self.localPrefix)
    }

    static func newId() -> String {
        return localPrefix + randomString(length: 10)
    }

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

extension Persistable {
    func delete() {
        managedObject().delete()
    }

    func save() {
        managedObject().save()
    }
}
