//
//  HikingListView.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct HikingListView: View {
    @State private var items: [ListItem] = []

    func fetchData() {
        items = ListItem.getAll() as! [ListItem]
        
        if items.count == 0 {
            items.append(ListItem(name: "new"))
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    HikingListItemRow(item: item) {
                        self.fetchData()
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .toolbar {
                EditButton()
                    .disabled(items.count == 0)
            }
            .navigationTitle(Text("item_list"))
            .onAppear {
                self.fetchData()
            }
        }
    }

    func delete(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { self.items[$0] }
        items.remove(atOffsets: offsets)

        ListItem.modifyIfNeeded {
            itemsToDelete.forEach({ item in
                item.deleteInWrite()
            })
        }

        fetchData()
    }

    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

struct HikingListView_Previews: PreviewProvider {
    static var previews: some View {
        HikingListView()
    }
}
