//
//  Realm+Utils.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import Combine
import RealmSwift
import SwiftUI

extension Object {
    //MARK: Instance methods
    
    @objc func modifyIfNeeded(_ block: () -> Void) {
        if DatabaseManager.Instance.realm.isInWriteTransaction {
            block()
        } else {
            modify(block)
        }
    }

    @objc func modify(_ block: () -> Void) {
        do {
            try DatabaseManager.Instance.realm.write(block)
        } catch {
            logger.error("An error occured while modifying this object \(error)")
        }
    }

    @objc func save() {
        do {
            try DatabaseManager.Instance.realm.write {
                DatabaseManager.Instance.realm.add(self, update: .modified)
            }
        } catch {
            logger.error("An error occured while creating/updating this object \(error)")
        }
    }

    @objc func saveInWrite() {
        DatabaseManager.Instance.realm.add(self, update: .modified)
    }

    @objc func delete() {
        do {
            try DatabaseManager.Instance.realm.write {
                DatabaseManager.Instance.realm.delete(self)
            }
        } catch {
            logger.error("An error occured while deleting this object \(error)")
        }
    }

    @objc func deleteInWrite() {
        DatabaseManager.Instance.realm.delete(self)
    }
    
    //MARK: Static methods
    
    @objc static func modifyIfNeeded(_ block: () -> Void) {
        if DatabaseManager.Instance.realm.isInWriteTransaction {
            block()
        } else {
            modify(block)
        }
    }
    
    @objc static func modify(_ block: () -> Void) {
        do {
            try DatabaseManager.Instance.realm.write(block)
        } catch {
            logger.error("An error occured while modifying this object \(error)")
        }
    }
    
    //MARK: Get methods
    
    static func getFirst(sortedBy sortKeyPath: String? = nil, ascending: Bool = true) -> Object? {
        var res = DatabaseManager.Instance.realm.objects(Self.self)

        if sortKeyPath != nil {
            res = res.sorted(byKeyPath: sortKeyPath!, ascending: ascending)
        }

        return res.first
    }
    
    static func getFirst(where fieldName: String, value: String?, sortedBy sortKeyPath: String? = nil, ascending: Bool = true) -> Object? {
        return getAll(where: fieldName, value: value, sortedBy: sortKeyPath, ascending: ascending).first
    }

    static func getOneById(id: String) -> Object? {
        DatabaseManager.Instance.realm.object(ofType: Self.self, forPrimaryKey: id)
    }

    static func getAll(where fieldName: String, value: String?, sortedBy sortKeyPath: String? = nil, ascending: Bool = true) -> [Object] {
        var res = DatabaseManager.Instance.realm.objects(Self.self)
        if value == nil {
            res = res.filter("\(fieldName)=nil")
        } else {
            res = res.filter("\(fieldName)=%@", value!)
        }
        if sortKeyPath != nil {
            res = res.sorted(byKeyPath: sortKeyPath!, ascending: ascending)
        }
        return res.toArray(ofType: Self.self)
    }

    static func getAll(filterIn fieldName: String, values: [String], sortedBy sortKeyPath: String? = nil, ascending: Bool = true) -> [Object] {
        var res = DatabaseManager.Instance.realm.objects(Self.self)
            .filterIn(fieldName: fieldName, values: values)
        if sortKeyPath != nil {
            res = res.sorted(byKeyPath: sortKeyPath!, ascending: ascending)
        }
        return res.toArray(ofType: Self.self)
    }

    static func getAll(sortedBy sortKeyPath: String? = nil, ascending: Bool = true) -> [Object] {
        var res = DatabaseManager.Instance.realm.objects(Self.self)

        if sortKeyPath != nil {
            res = res.sorted(byKeyPath: sortKeyPath!, ascending: ascending)
        }

        return res.toArray(ofType: Self.self)
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }

    func filterIn(fieldName: String, values: [String]) -> Results<Element> {
        if values.count == 0 {
            return filter(NSPredicate(value: false))
        }
        return filter(values.map({ (value) -> String in
            String(format: "\(fieldName) == '%@'", value)
        }).joined(separator: " OR "))
    }
}

extension RealmSwift.List {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}

func assertTypeIsEncodable<T>(_ type: T.Type, in wrappingType: Any.Type) {
    guard T.self is Encodable.Type else {
        if T.self == Encodable.self || T.self == Codable.self {
            preconditionFailure("\(wrappingType) does not conform to Encodable because Encodable does not conform to itself. You must use a concrete type to encode or decode.")
        } else {
            preconditionFailure("\(wrappingType) does not conform to Encodable because \(T.self) does not conform to Encodable.")
        }
    }
}

func assertTypeIsDecodable<T>(_ type: T.Type, in wrappingType: Any.Type) {
    guard T.self is Decodable.Type else {
        if T.self == Decodable.self || T.self == Codable.self {
            preconditionFailure("\(wrappingType) does not conform to Decodable because Decodable does not conform to itself. You must use a concrete type to encode or decode.")
        } else {
            preconditionFailure("\(wrappingType) does not conform to Decodable because \(T.self) does not conform to Decodable.")
        }
    }
}
