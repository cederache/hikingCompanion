//
//  ListItemRow.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct ListItemRow: View {
    @EnvironmentObject var listItemsStore: ListItemsStore
    
    var itemId: String
    var update: (() -> Void)?
    var isNewItem: Bool = false

    @State private var text: String = ""

    var item: ListItem? {
        isNewItem ? nil : listItemsStore.listItems.first(where: { $0.id == itemId })
    }

    func onChange() {
        if item?.name.isEmpty ?? false || item?.name.replacingOccurrences(of: " ", with: "").isEmpty ?? false {
            if !isNewItem {
                // Can't delete an item not saved
                item?.delete()
            }
        } else {
            if isNewItem {
                // Create a new ListItem and reset forced one
                let newItem = ListItem(name: text)
                newItem.save()
                text = ""
            } else {
                item?.save()
            }
        }
        update?()
    }
    
    var emptyNewItem: Bool {
        isNewItem && text.isEmpty
    }

    var body: some View {
        HStack {
            Button(action: {
                item?.done.toggle()
                self.onChange()
            }) {
                Group {
                    if emptyNewItem {
                        Image(systemName: "plus")
                    } else if item?.done ?? false {
                        Circle()
                            .fill()
                    } else {
                        Circle()
                            .stroke()
                    }
                }
                .frame(width: 20, height: 20)
                .padding([.trailing], 5)
            }
            .foregroundColor(.accentColor)
            .disabled(emptyNewItem)
            
            TextField("", text: $text) { _ in
            } onCommit: {
                self.item?.name = text
                self.onChange()
            }
            .foregroundColor(item?.done ?? false ? .secondary : .primary)
            .onAppear {
                text = self.item?.name ?? ""
            }
        }
    }
}

extension ListItemRow {
    init(itemId: String, update:(()->Void)? = nil) {
        self.itemId = itemId
        self.isNewItem = false
        self.update = update
    }
    
    init(isNewItem: Bool, update:(()->Void)? = nil) {
        itemId = ""
        self.isNewItem = isNewItem
        self.update = update
    }
}

struct HikingListItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ListItemRow(itemId: "")
    }
}
