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

    @EnvironmentObject var globalState: GlobalState
    @State private var hasInitializedFavoritesUpdated = false
    @State private var hasInitializedGlobalRefresh = false
    
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
                        .fontWeight(.bold)
                    Spacer()
                    Text("See all")
                        .font(.callout)
                        .fontWeight(.bold)
                    Image(systemName: "chevron.right")
                        .padding(.trailing, 8)
                }
                .contentShape(Rectangle()) // Makes the entire HStack tappable
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
                                    await viewModel.getItems()
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.clear)
        .onReceive(globalState.$favoritesUpdated) { favoritesUpdated in
            if (!hasInitializedFavoritesUpdated) {
                hasInitializedFavoritesUpdated = true
                return
            }
            if itemType == .favorite {
                Task {
                    await viewModel.getItems()
                }
            }
        }
        .onReceive(globalState.$globalRefresh) { globalRefresh in
            if (!hasInitializedGlobalRefresh) {
                hasInitializedGlobalRefresh = true
                return
            }   
            viewModel.resetItems()
            Task {
                await viewModel.getItems()
            }
        }
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

            Text(item.name)
                .font(.caption)
                .padding(2)
        }
        .frame(width: 110, height: 185)
        .padding(2)
    }
}
