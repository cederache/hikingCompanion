//
//  ListItemsStore.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 01/07/2021.
//

import Combine
import Foundation

class ListItemsStore: ObservableObject {
    static let Instance = ListItemsStore()
    
    @Published var listItems: [ListItem] = []
    
    private init() {}
    
    func fetch() {
        listItems = ListItem.getAll(sortedBy: "_order", ascending: true) as? [ListItem] ?? []
        for listItem in listItems {
            listItem.fetchChildren()
        }
    }
}
