//
//  HikingListView.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct HikingListView: View {
    @EnvironmentObject var listItemsStore: ListItemsStore

    func fetchData() {
        listItemsStore.fetch()
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(listItemsStore.listItems) { item in
                        HikingListItemRow(itemId: item.id) {
                            self.fetchData()
                        }

                        if item.expanded {
                            ForEach(item.subItems()) { subItem in
                                HikingListItemRow(itemId: subItem.id) {
                                    self.fetchData()
                                }
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
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

                HStack {
                    Button(action: {
                        let newItem = ListItem(name: "")
                        newItem.save()
                        listItemsStore.listItems.append(newItem)
                    }) {
                        Image(systemName: "plus.circle.fill")
                        Text("new_item")
                    }
                    .foregroundColor(.accentColor)
                    
                    Spacer()
                }
                .padding()
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
        HikingListView()
    }
}
