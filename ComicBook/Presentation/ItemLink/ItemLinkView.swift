//
//  ItemLinkView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 5/15/24.
//

import SwiftUI

struct ItemLinkView : View {
    let itemType: ItemType
    let detailItem: Item?

    var body: some View {
        NavigationLink {
            ItemVListView(
                itemType: itemType,
                detailItem: detailItem,
                repository: ComicBookRepositoryImpl.shared
            )
        } label: {
            ItemHListView(
                itemType: itemType,
                detailItem: detailItem,
                repository: ComicBookRepositoryImpl.shared
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
