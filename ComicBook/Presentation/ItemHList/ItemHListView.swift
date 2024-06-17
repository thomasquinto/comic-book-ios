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
    let sizeFactor: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 0.6875 : 1.0

    @State var viewModel: ItemHListViewModel

    @Environment(GlobalState.self) var globalState
    
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
                .padding(.top, 16)
            }
                
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.items) { item in
                        NavigationLink {
                            ItemDetailView(item: item, repository: repository)
                        } label: {
                            ItemLabel(item: item, sizeFactor: sizeFactor)
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
        .onChange(of: globalState.favoritesUpdated, initial: true) { favoritesUpdated, initial in
            if initial {
                return
            }
            if itemType == .favorite {
                Task {
                    await viewModel.getItems()
                }
            }
        }
        .onChange(of: globalState.globalRefresh, initial: true) { globalRefresh, initial in
            if initial {
                return
            }   
            viewModel.resetItems()
            Task {
                await viewModel.getItems()
            }
        }
    }
}
