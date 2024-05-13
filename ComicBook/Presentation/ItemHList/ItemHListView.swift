//
//  ItemListHorizontalView.swift
//  ComicBook
//
//  Created by Thomas Quinto on 4/30/24.
//

import SwiftUI
import CachedAsyncImage

struct ItemHListView: View {
    let id: Int
    let name: String
    let fetchDetails: (Int, Int, Int, String?) async throws -> [Item]
    let makeDetailView: (Item, ItemType) -> AnyView
    @State var viewModel: ItemHListViewModel

    init(id: Int,
         name: String,
         fetchDetails: @escaping (Int, Int, Int, String?) async throws -> [Item],
         makeDetailView: @escaping (Item, ItemType) -> AnyView
    ) {
        self.id = id
        self.name = name
        self.fetchDetails = fetchDetails
        self.makeDetailView = makeDetailView
        self.viewModel = .init(id: id, fetchDetails: fetchDetails)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.items.isEmpty {
                HStack {
                    Text(name)
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    if id == 0 {
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
                            makeDetailView(item, item.itemType)
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
