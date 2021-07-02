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
    @objc internal dynamic var _parentId: String?
    @objc internal dynamic var _order: Int = 0
    @objc internal dynamic var _name: String = ""
    @objc internal dynamic var _done: Bool = false
    @objc internal dynamic var _expanded: Bool = false
    
    private var _subItems: [ListItem]? = nil
    private var _parentItem: ListItem? = nil
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case _id = "id"
        case _parentId = "parent_id"
        case _order = "order"
        case _name = "name"
        case _done = "done"
        case _expanded = "expanded"
    }
    
    override init() {
        super.init()
        _id = self.newId()
    }
    
    // MARK: Safe vars
    
    var id: String {
        self.isInvalidated ? "" : _id
    }
    
    var parentId: String? {
        get {
            self.isInvalidated ? nil : _parentId
        } set {
            if !self.isInvalidated {
                modifyIfNeeded {
                    let oldValue = _parentId
                    _parentId = newValue
                    
                    // Reset order from previous parentId subItems
                    let items = ListItem.getAll(where: "_parentId", value: oldValue) as? [ListItem] ?? []
                    for(index, item) in items.filter({ $0.id != id }).sorted(by: { $0.order > $1.order }).enumerated() {
                        item.order = index
                    }
                }
            }
        }
    }
    
    var order: Int {
        get {
            self.isInvalidated ? 0 : _order
        } set {
            if !self.isInvalidated {
                modifyIfNeeded {
                    let oldValue = _order
                    _order = newValue
                    let items = ListItem.getAll(where: "_parentId", value: parentId) as? [ListItem] ?? []
                    items.filter({ $0.id != id }).forEach { item in
                        if item.order > newValue && item.order < oldValue {
                            item.order += 1
                        } else if item.order > oldValue && item.order < newValue {
                            item.order -= 1
                        }
                    }
                }
            }
        }
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
    
    var done: Bool {
        get {
            self.isInvalidated ? false : _done
        } set {
            if !self.isInvalidated {
                modifyIfNeeded {
                    _done = newValue
                    if let parentItem = parentItem() {
                        // Set done to false on parentItem if we undo a subItem
                        if newValue == false && parentItem.done == true {
                            parentItem.done = false
                        } else if newValue == true && parentItem.subItems().allSatisfy({ $0.done == true }) {
                            // Set done to true on parentItem if every subItems is true
                            parentItem.done = true
                        }
                        parentItem.save()
                    }
                }
            }
        }
    }
    
    var expanded: Bool {
        get {
            self.isInvalidated ? false : _expanded
        } set {
            if !self.isInvalidated {
                modifyIfNeeded {
                    _expanded = newValue
                }
            }
        }
    }
    
    // MARK: Helpers
    
    func subItems(forceFetch: Bool = false) -> [ListItem] {
        if !forceFetch && _subItems != nil {
            return _subItems ?? []
        }
        _subItems = ListItem.getAll(where: "_parentId", value: id) as? [ListItem]
        return _subItems ?? []
    }
    
    func parentItem(forceFetch: Bool = false) -> ListItem? {
        if !forceFetch && _parentItem != nil {
            return _parentItem
        }
        guard let parentId = parentId else {
            return nil
        }
        _parentItem = ListItem.getOneById(id: parentId) as? ListItem
        return _parentItem
    }
}

extension ListItem {
    convenience init(name: String) {
        self.init()
        self.name = name
        self.order = ListItem.MaxOrder(withParentId: parentId) + 1
    }
}

extension ListItem {
    static func MaxOrder(withParentId parentId: String?) -> Int {
        return (ListItem.getAll(where: "_parentId", value: parentId) as? [ListItem] ?? []).map({ $0.order }).max() ?? -1
    }
}
