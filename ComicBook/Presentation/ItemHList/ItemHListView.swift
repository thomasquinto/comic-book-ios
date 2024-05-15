//
//  ItemListHorizontalView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import SwiftUI
import CachedAsyncImage

struct ItemHListView: View {
    let itemType: ItemType
    let detailItem: Item?
    let repository: ComicBookRepository

    @State var viewModel: ItemHListViewModel

    init(itemType: ItemType,
         detailItem: Item?,
         repository: ComicBookRepository
    ) {
        self.itemType = itemType
        self.detailItem = detailItem
        self.repository = repository
        _viewModel = State(initialValue: ItemHListViewModel(itemType: itemType, detailItem: detailItem, repository: repository))
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.items.isEmpty {
                HStack {
                    Text(itemType.rawValue.capitalized)
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    if detailItem == nil {
                        Spacer()
                        Text("See all")
                            .font(.callout)
                    }
                }
            }
                
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.items) { item in
                        NavigationLink {
                            ItemDetailView(item: item, repository: repository)
                        } label: {
                            ItemHorizontalLabel(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    if !viewModel.hasNoMore {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .opacity(0.0)
                            .onAppear {
                                Task {
                                    await viewModel.getItems(reset: false)
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.clear)
    }
}

struct ItemHorizontalLabel: View {
    let item: Item

    var body: some View {
        VStack{
            CachedAsyncImage(url: URL(string: item.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 165)
                    .clipped()
                    .cornerRadius(6)
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 110, height: 165)
                    .cornerRadius(6)
            }

            Spacer()

            Text(item.title)
                .font(.caption)
                .padding(2)
        }
        .frame(width: 110, height: 185)
        .padding(2)
    }
}
