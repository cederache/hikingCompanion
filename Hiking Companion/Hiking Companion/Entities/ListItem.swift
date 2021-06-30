//
//  ListItem.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import Foundation
import RealmSwift

class ListItem: Object, EntitySafe, Codable, Identifiable {
    @objc dynamic var _id: String = ""
    @objc internal dynamic var _name: String = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case _id = "id"
        case _name = "name"
    }
    
    override init() {
        _id = ""
        _name = ""
    }
    
    // MARK: Safe vars
    
    var id: String {
        self.isInvalidated ? "" : _id
    }

    var name: String {
        get {
            self.isInvalidated ? "" : _name
        } set {
            if !self.isInvalidated {
                modifyIfNeeded {
                    _name = newValue
                }
            }
        }
    }
}

extension ListItem {
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
