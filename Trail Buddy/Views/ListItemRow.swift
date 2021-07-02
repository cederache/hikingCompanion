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

    @State private var text: String = ""

    var item: ListItem? {
        listItemsStore.listItems.first(where: { $0.id == itemId })
    }

    func onChange() {
        item?.save()
        update?()
    }

    var body: some View {
        HStack {
            Button(action: {
                item?.done.toggle()
                self.onChange()
            }) {
                if item?.done ?? false {
                    Circle()
                        .fill()
                } else {
                    Circle()
                        .stroke()
                }
            }
            .foregroundColor(.accentColor)
            .frame(width: 20, height: 20)
            
            TextField("", text: $text) { _ in
            } onCommit: {
                self.item?.name = text
                self.onChange()
            }
            .foregroundColor(item?.done ?? false ? .secondary : .primary)
            .onAppear {
                text = self.item?.name ?? ""
            }

            if self.item?.subItems().count ?? 0 > 0 {
                Button(action: {
                    self.item?.expanded.toggle()
                }) {
                    Image(self.item?.expanded ?? false ? "chevron.down" : "chevron.right")
                }
            }
        }
    }
}

struct HikingListItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ListItemRow(itemId: "")
    }
}
