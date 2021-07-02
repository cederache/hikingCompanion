//
//  ListView.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listItemsStore: ListItemsStore

    func fetchData() {
        listItemsStore.fetch()
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(listItemsStore.listItems) { item in
                        ListItemRow(itemId: item.id) {
                            self.fetchData()
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)

                    ListItemRow(isNewItem: true) {
                        self.fetchData()
                    }
                }
                .toolbar {
                    EditButton()
                        .disabled(listItemsStore.listItems.count == 0)
                }
                .navigationTitle(Text("item_list"))
                .onAppear {
                    self.fetchData()
                }
                .listStyle(PlainListStyle())
            }
        }
    }

    func delete(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { self.listItemsStore.listItems[$0] }
        listItemsStore.listItems.remove(atOffsets: offsets)

        ListItem.modifyIfNeeded {
            itemsToDelete.forEach({ item in
                item.deleteInWrite()
            })
        }

        fetchData()
    }

    func move(from source: IndexSet, to destination: Int) {
        listItemsStore.listItems.move(fromOffsets: source, toOffset: destination)
    }
}

struct HikingListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
