//
//  HikingListItemRow.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct HikingListItemRow: View {
    var item: ListItem
    
    var update: (() -> Void)?
    
    @State private var text: String = ""
    
    var body: some View {
        TextField("", text: $text) { status in
            logger.debug("onEditingChange \(status) \(text)")
        } onCommit: {
            logger.debug("onCommit \(text)")
            item.name = text
            item.save()
            update?()
        }
        .onAppear {
            text = item.name
        }
    }
}

struct HikingListItemRow_Previews: PreviewProvider {
    static var previews: some View {
        HikingListItemRow(item: ListItem())
    }
}
