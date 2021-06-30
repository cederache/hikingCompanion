//
//  HikingListView.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct HikingListView: View {
    @State private var items = ["Bag", "Shoes", "Tent"]

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle(Text("item_list"))
        }
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
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
